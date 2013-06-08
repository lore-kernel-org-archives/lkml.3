Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3FHDwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 23:52:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51956 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3FHDw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 23:52:28 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 7 Jun 2013 20:53:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.9.5
Message-ID: <20130608035312.GA16419@roeck-us.net>
References: <20130607195816.GA28479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607195816.GA28479@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:58:16PM -0700, Greg KH wrote:
> I'm announcing the release of the 3.9.5 kernel.
> 
> All users of the 3.9 kernel series must upgrade.
> 
> The updated 3.9.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
> and can be browsed at the normal kernel.org git web browser:
> 	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 
powerpc build fails:

arch/powerpc/kernel/traps.c: In function 'alignment_exception':
arch/powerpc/kernel/traps.c:1154:3: error: label 'bail' used but not defined
make[1]: *** [arch/powerpc/kernel/traps.o] Error 1
make[1]: *** Waiting for unfinished jobs....

Due to commit 6ce6c629 (powerpc/tm: Abort on emulation and alignment faults).

Guenter
