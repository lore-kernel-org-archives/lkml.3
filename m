Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3KRBx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:53:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49425 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3KRBxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:53:51 -0500
Date: Sun, 17 Nov 2013 19:53:47 -0600
From: rkuo <rkuo@codeaurora.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 04/11] hexagon: use generic fixmap.h
Message-ID: <20131118015347.GA14896@codeaurora.org>
References: <1384262545-20875-1-git-send-email-msalter@redhat.com>
 <1384262545-20875-5-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384262545-20875-5-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:22:18AM -0500, Mark Salter wrote:
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Richard Kuo <rkuo@codeaurora.org>
> CC: linux-hexagon@vger.kernel.org
> ---
>  arch/hexagon/include/asm/fixmap.h | 40 +--------------------------------------
>  1 file changed, 1 insertion(+), 39 deletions(-)
> 

Thanks for the cleanup!


Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
