Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaCCQCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:02:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47763 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaCCQCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:02:21 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH V9 2/2] ARM: dts: Enable ahci sata and sata phy
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <53146E84.7060508@ti.com>
Date: Mon, 3 Mar 2014 10:02:13 -0600
Cc: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        mark.rutland@arm.com, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        sander@humilis.net, swarren@wwwdotorg.org, b.zolnierkie@samsung.com,
        ks.giri@samsung.com, t.figa@samsung.com, jg1.han@samsung.com,
        joshi@samsung.com, grant.likely@linaro.org,
        christoffer.dall@linaro.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C12D2EA6-2766-4C9A-8746-9B8E1A5844CD@codeaurora.org>
References: <1393824160-27040-1-git-send-email-yuvaraj.cd@samsung.com> <1393824160-27040-3-git-send-email-yuvaraj.cd@samsung.com> <53146E84.7060508@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 3, 2014, at 5:59 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:

> 
> 
> On Monday 03 March 2014 10:52 AM, Yuvaraj Kumar C D wrote:
>> This patch adds dt entry for ahci sata controller and its
>> corresponding phy controller.phy node has been added w.r.t
>> new generic phy framework.
>> 
>> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> 
> This should go via exynos dt tree.
> 
> FWIW
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
>> —

Its a nit, but the subject really should have ‘exynos’ or some related qualifier.  We aren’t enabling ahci sata & phy for all of ARM

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

