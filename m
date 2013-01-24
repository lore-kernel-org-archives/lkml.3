Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3AXCXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:23:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:33856 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab3AXCWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:22:55 -0500
Date: Wed, 23 Jan 2013 18:24:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sven =?iso-8859-1?Q?K=F6hler?= <sven.koehler@gmail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.7.4
Message-ID: <20130124022425.GA5721@kroah.com>
References: <20130121195420.GA6534@kroah.com>
 <kdq4sd$g3c$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <kdq4sd$g3c$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 03:06:29AM +0100, Sven Köhler wrote:
> Hi,
> 
> I had to revert this, because it resulted in
> 
>   LD      init/built-in.o
> arch/x86/built-in.o: In function `setup_arch':
> (.init.text+0x359e): undefined reference to `early_pci_allowed'
> arch/x86/built-in.o: In function `setup_arch':
> (.init.text+0x35b2): undefined reference to `read_pci_config_16'
> arch/x86/built-in.o: In function `setup_arch':
> (.init.text+0x35cb): undefined reference to `read_pci_config_16'
> make[1]: *** [vmlinux] Fehler 1
> make: *** [sub-make] Fehler 2
> 
> I'm building a Xen domU kernel without modules (one big binary of
> everything).


You had to revert _what_?

confused,

greg k-h
