Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaGVC12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:27:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaGVC11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:27:27 -0400
Date: Mon, 21 Jul 2014 19:27:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eunbong Song <eunb.song@samsung.com>
Cc: "chanho.min@lge.com" <chanho.min@lge.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] lib : lz4 using put_unaligned_le16 instead of
 put_unaligned
Message-ID: <20140722022727.GA20325@kroah.com>
References: <12396088.204011405995472026.JavaMail.weblogic@epml18>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12396088.204011405995472026.JavaMail.weblogic@epml18>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:17:52AM +0000, Eunbong Song wrote:
> 
> > Odd line wrapping :(
> 
> Sorry, for this. 
> 
> > Anyway, is this a new problem?  Or something that has always been there
> > in this compression function?
> 
> Actually, i have tested zram with lz4 functions in my board(mips64 big endian). 
> Everytime  i try to mount my ext4 zram image i have failed. 
> After applying this patch, that problem was disappeared.

So it's never worked?

Did you test on a little endian machine after making this change?
