Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaIXSeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:34:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40165 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaIXSeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:34:04 -0400
Message-ID: <54230E9A.7020109@codeaurora.org>
Date: Wed, 24 Sep 2014 11:34:02 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: qcom: Update SoC compatibles we support
References: <1411582838-24159-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1411582838-24159-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 11:20, Kumar Gala wrote:
> Move to just using the SoC name in the compatible list so we don't need
> to update this for every board going forward.  Also added "qcom,msm8974"
> to the list as we support "qcom,apq8074" already (the modemless version
> of "qcom,msm8974").
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---

Or just remove the file entirely. Things work without having to add
anything here anyway.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

