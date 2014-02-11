Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaBKWyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:54:23 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35840 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaBKWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:54:22 -0500
MIME-Version: 1.0
In-Reply-To: <1392150126-21744-1-git-send-email-galak@codeaurora.org>
References: <1392150126-21744-1-git-send-email-galak@codeaurora.org>
Date: Wed, 12 Feb 2014 02:46:07 +0400
Message-ID: <CALT56yO7rq4SXRnNpZgtmJYhVXzKy7oxuj9pAxFmXtbdnd=osA@mail.gmail.com>
Subject: Re: [PATCH] power: reset: msm - switch Kconfig to ARCH_QCOM depends
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:22 AM, Kumar Gala <galak@codeaurora.org> wrote:
> We've split Qualcomm MSM support into legacy and multiplatform.  The reset
> driver is only relevant on the multiplatform supported SoCs so switch the
> Kconfig depends to ARCH_QCOM.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Acked-by: Dmitry Eremin-Solenikov

> ---
> Dmitry, David,
>
> If you can ack this I'll send it via linux-qcom/arm-soc tree's

Please, go ahead.

>
> thanks



-- 
With best wishes
Dmitry
