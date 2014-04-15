Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaDOR45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:56:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39118 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDOR4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:56:54 -0400
Message-ID: <534D72E5.1000805@codeaurora.org>
Date: Tue, 15 Apr 2014 10:56:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Mark Brown <broonie@kernel.org>
CC: Saravana Kannan <skannan@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Wagantall <mattw@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Support qcom GDSC hardware
References: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 11:45, Stephen Boyd wrote:
> These patches add support for the multimedia GDSCs on the
> apq8074 dragonboard. The first two patches (and potentially the last)
> should go through Mike's tree and the DTS patch should go through
> the qcom tree. Patches are based on v3.14. The probe will conflict with
> patches I sent to consolidate things. I'll rework these patches on top of
> that if the gdsc.c file is acked/reviewed.

Any comments?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

