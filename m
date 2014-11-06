Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaKFPmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:42:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKFPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:42:31 -0500
Date: Thu, 6 Nov 2014 07:41:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Message-ID: <20141106154120.GB19605@kroah.com>
References: <wrfjy4rxzk5b.fsf@redhat.com>
 <1415254573-3451-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415254573-3451-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please specify the "error" in the subject in some way.

On Thu, Nov 06, 2014 at 11:46:13AM +0530, Sanjeev Sharma wrote:
> This is a patch to the rtw_cmd.c file that fixes following
> error.
> 
> ERROR: spaces required around that '>' (ctx:WxV)
> ERROR: that open brace { should be on the previous line
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 83 +++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 43 deletions(-)

This does two different things, please make it different patches.

And you sent 2 patches, with no hint as to which one comes before which.
Please resend all of them, correctly numbered in a series, so that I
have a chance to get the order correct when applying them.
