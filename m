Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3CYK7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:59:45 -0400
Received: from plane.gmane.org ([80.91.229.3]:58498 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab3CYK7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:59:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [media] videobuf2-core: print current state of buffer in =?utf-8?b?dmIyX2J1ZmZlcl9kb25l?=
Date: Mon, 25 Mar 2013 10:53:30 +0000 (UTC)
Message-ID: <loom.20130325T115241-237@post.gmane.org>
References: <1352707289-9349-1-git-send-email-tushar.behera@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.67.201.162 (Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; InfoPath.2; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; MS-RTC LM 8))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tushar Behera <tushar.behera <at> linaro.org> writes:

> In vb2_buffer_done, it would be better the print the value of 'state'
> (current state of buffer) than to print 'vb->state' which is always
> VB2_BUF_STATE_ACTIVE.
> 
> Signed-off-by: Tushar Behera <tushar.behera <at> linaro.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)




