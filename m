Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaIQLSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:18:23 -0400
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:53931 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbaIQLSU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:18:20 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Date: Wed, 17 Sep 2014 07:18:19 -0400 (EDT)
Subject: Re: [PATCH] ARM: dts: qcom: Add I2C dt node for MSM8974 and DB8074 board
From: kiran.padwal@smartplayin.com
To: "Kumar Gala" <galak@codeaurora.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org, afaerber@suse.de,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <306266B7-29AB-474E-855E-F0BE55C9BA11@codeaurora.org>
References: <1410867938-6254-1-git-send-email-kiran.padwal@smartplayin.com> 
 <306266B7-29AB-474E-855E-F0BE55C9BA11@codeaurora.org>
Message-ID: <1410952699.0923113@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

On Tuesday, September 16, 2014 2:59pm, "Kumar Gala" <galak@codeaurora.org> said:

> 
> On Sep 16, 2014, at 4:45 AM, Kiran Padwal <kiran.padwal@smartplayin.com> wrote:
> 
>> Add support for i2c controller on the DB8074 board.
>> It also adds necessary DT support for i2c eeprom which is present on
>> DB8074 board.
>>
>> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>> ---
>> arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |   21 +++++++++++++++++++++
>> arch/arm/boot/dts/qcom-msm8974.dtsi            |   15 +++++++++++++--
>> 2 files changed, 34 insertions(+), 2 deletions(-)
> 
> Can you rebase this on:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git
> tags/qcom-dt-for-3.18

This patches apply on this tree with no warnings/errors.

> 
> - k
> 
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The
> Linux Foundation
> 
> 


