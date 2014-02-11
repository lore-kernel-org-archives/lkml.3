Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaBKPAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:00:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39120 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBKPAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:00:48 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 2/5] clocksource: qcom: Move clocksource code out of mach-msm
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <52F9ECC7.8010702@linaro.org>
Date: Tue, 11 Feb 2014 09:00:44 -0600
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0038EEDD-6836-4171-9EB9-C1A70029AE8D@codeaurora.org>
References: <1391553421-26914-1-git-send-email-galak@codeaurora.org> <1391553421-26914-3-git-send-email-galak@codeaurora.org> <52F9ECC7.8010702@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 11, 2014, at 3:26 AM, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> On 02/04/2014 11:36 PM, Kumar Gala wrote:
>> We intent to share the clocksource code for MSM platforms between legacy
>> and multiplatform supported qcom SoCs.
>> 
>> Acked-by: Olof Johansson <olof@lixom.net>
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> 
> Hi Kumar,
> 
> through which tree do you expect this patch to be upstream ?

The linux-qcom to keep things sane there.  So an ack would be great.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

