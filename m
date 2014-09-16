Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaIPS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:59:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51087 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaIPS7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:59:43 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] ARM: dts: qcom: Add I2C dt node for MSM8974 and DB8074 board
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1410867938-6254-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Tue, 16 Sep 2014 11:59:39 -0700
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org, afaerber@suse.de,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <306266B7-29AB-474E-855E-F0BE55C9BA11@codeaurora.org>
References: <1410867938-6254-1-git-send-email-kiran.padwal@smartplayin.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 16, 2014, at 4:45 AM, Kiran Padwal <kiran.padwal@smartplayin.com> wrote:

> Add support for i2c controller on the DB8074 board.
> It also adds necessary DT support for i2c eeprom which is present on
> DB8074 board.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
> arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |   21 +++++++++++++++++++++
> arch/arm/boot/dts/qcom-msm8974.dtsi            |   15 +++++++++++++--
> 2 files changed, 34 insertions(+), 2 deletions(-)

Can you rebase this on:

 git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

