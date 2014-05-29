Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaE2Uid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:38:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaE2Uic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:38:32 -0400
Date: Thu, 29 May 2014 13:42:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: devel@driverdev.osuosl.org, Sunghwan Yun <sunghwan.yun@samsung.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-kernel@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Dongjun Shin <d.j.shin@samsung.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH v2 1/9] staging: ion: tidy up a bit
Message-ID: <20140529204208.GA2120@kroah.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-2-git-send-email-heesub.shin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401259980-26927-2-git-send-email-heesub.shin@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:52:52PM +0900, Heesub Shin wrote:
> For aesthetics and readability, rename goto labels, remove
> useless code lines, and clarify function return type.
> 
> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
> Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>
> Tested-by: John Stultz <john.stultz@linaro.org>

Not all of these would apply to my tree.  So I've applied the ones that
did.  Please resend the remaining ones, after refreshing them against my
staging-next branch of the staging.git tree.

thanks,

greg k-h
