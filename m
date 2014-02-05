Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaBEP2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:28:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38051 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBEP2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:28:03 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2 0/5] Split mach-msm into legacy and mach-qcom (multiplatform)
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140205004732.GB12815@codeaurora.org>
Date: Wed, 5 Feb 2014 09:27:57 -0600
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <86DB2204-BB01-4B64-AF0C-5A0045DA8ABD@codeaurora.org>
References: <1391553532-27001-1-git-send-email-galak@codeaurora.org> <20140205004732.GB12815@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4, 2014, at 6:47 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 02/04, Kumar Gala wrote:
>> This is the splits the Qualcomm MSM platform into legacy support that we will
>> not try and convert to multiplatform and multiplatform support.
>> 
>> - k
>> 
>> Changes from v1:
>> * Added patch to remove hotplug.c
>> * Added patch to rename msm_ to qcom_
>> * Changes the Kconfig to drop CPU_V7
>> * used wfi() in cpu_die function
>> * Added git tree to MAINTAINERS file
> 
> What's the plan for this series combined with my SMP series? It
> looks like this isn't based on those patches, so we'll have some
> conflicts with the msm to qcom rename but it should be fairly
> minor.

I’ve rebased the smp patch series on top of this set, so will post the new version short (hopefully once we close on these).

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

