Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaDRXBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:01:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaDRXBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:01:51 -0400
Date: Fri, 18 Apr 2014 16:02:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matei Oprea <eu@opreamatei.ro>
Cc: devel@driverdev.osuosl.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u: r8192U_wx: Fix sparse warnings
Message-ID: <20140418230200.GA966@kroah.com>
References: <1395410869-19362-1-git-send-email-eu@opreamatei.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395410869-19362-1-git-send-email-eu@opreamatei.ro>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 04:07:49PM +0200, Matei Oprea wrote:
> Fix sparse "should be static" warnings. Those structures are
> only referenced in file scope so they can be marked as static.
> 
> Signed-off-by: Matei Oprea <eu@opreamatei.ro>
> Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
> ---
>  drivers/staging/rtl8192u/r8192U_wx.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This patch breaks the build, how did you test it?

