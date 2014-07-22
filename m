Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaGVCLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:11:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaGVCLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:11:38 -0400
Date: Mon, 21 Jul 2014 19:11:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eunbong Song <eunb.song@samsung.com>
Cc: chanho.min@lge.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib : lz4 using put_unaligned_le16 instead of
 put_unaligned
Message-ID: <20140722021137.GD19215@kroah.com>
References: <6506286.203381405994602250.JavaMail.weblogic@epml18>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6506286.203381405994602250.JavaMail.weblogic@epml18>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:03:22AM +0000, Eunbong Song wrote:
> 
> In case of mips bigendian machine, put_unaligned writes bigendian bytes order. 
> This is defined in arch/mips/include/asm/unaligned.h. So it's right use put_unaligned_le16 function instead of put_unaligned.
> This patch also fixes problem fail to mount zram ext4 partition with "zram: Decompression failed! err=-1, page=0" in mips bigendian machine.

Odd line wrapping :(

Anyway, is this a new problem?  Or something that has always been there
in this compression function?

thanks,

greg k-h
