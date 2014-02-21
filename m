Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaBUBC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:02:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54035 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbaBUBCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:02:53 -0500
Message-ID: <5306A5BC.8010409@codeaurora.org>
Date: Thu, 20 Feb 2014 17:02:52 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm-perf
 tree
References: <20140221115857.3ea3d7277d03c5b6b4d26488@canb.auug.org.au>
In-Reply-To: <20140221115857.3ea3d7277d03c5b6b4d26488@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/14 16:58, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/boot/dts/qcom-msm8960-cdp.dts between commit a1d711938959 ("ARM:
> dts: msm: Add krait-pmu to platforms with Krait CPUs") from the arm-perf
> tree and commit cc60a1a4d47a ("ARM: dts: msm: split out msm8660 and
> msm8960 soc into dts include") from the arm-soc tree.
>
> I fixed it up (probably not the best way ... see below) and can carry the
> fix as necessary (no action is required).
>

It's good enough to be correct, but it would be better if the pmu node
went into the arch/arm/boot/dts/qcom-msm8960.dtsi file in the arm-soc tree.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

