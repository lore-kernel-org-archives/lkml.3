Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3IIB4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 21:56:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3IIB4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 21:56:42 -0400
Date: Sun, 8 Sep 2013 18:59:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Peng Tao <tao.peng@emc.com>, Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130909015945.GA4029@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 06:03:00PM -0700, Guenter Roeck wrote:
> mips allmodconfig fails with
> 
> ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
> undefined!
> 
> which is due to LUSTRE using copy_from_user_page which is not exported by any
> architecture.

Any, or just these arches?

> Unfortunately, LUSTRE can only be built as module, so there is no
> easy fix.

Can't we just export the functions for those arches?  Surely lutre
isn't the first/only driver that needs this?

thanks,

greg k-h
