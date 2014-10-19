Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaJSWG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:06:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaJSWGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:06:53 -0400
Date: Mon, 20 Oct 2014 06:05:47 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-api@vger.kernel.org, Anup Patel <anup.patel@linaro.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Message-ID: <20141019220547.GC3780@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <20141017092601.GH23154@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017092601.GH23154@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 12:26:01PM +0300, Dan Carpenter wrote:
> The code isn't very beautiful and there are lots of details wrong like
> the error codes.

Really, what is wrong with the existing error code usages?

> Al had some critical things to say about it but it looks like most of
> those issues have been fixed.

All of the ones that can be fixed, have, as far as I know.

We are stuck with some that we can't fix, which is ok as it is safe in
the Android user model.

thanks,

greg k-h
