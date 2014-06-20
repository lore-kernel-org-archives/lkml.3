Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988AbaFTQmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:42:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaFTQmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:42:04 -0400
Date: Fri, 20 Jun 2014 09:46:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] thunderbolt: add PCI dependency
Message-ID: <20140620164605.GA29765@kroah.com>
References: <1403272331-3790755-1-git-send-email-arnd@arndb.de>
 <CAMxnaaUThGenvkYkcx062tjwYgBnBDsXNsUzeFtrUa7AV8Pk-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaUThGenvkYkcx062tjwYgBnBDsXNsUzeFtrUa7AV8Pk-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 04:44:05PM +0200, Andreas Noever wrote:
> Thanks for the series.
> 
> Patch 2 is equivalent to patches 1 and 2 from Sachin Kamat's series.
> 
> @Greg: This series together with Sachin's patches should fix all build
> errors. I'll send patches for the remaining warnings later.

Thanks, I'll apply patches 1 and 3 here.

greg k-h
