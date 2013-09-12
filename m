Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3ILT05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:26:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38180 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3ILT0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:26:55 -0400
Subject: Re: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAOesGMhSZzpyT5XyECByLnvef0E+92y+uaXByiG0Vpm9f05AxQ@mail.gmail.com>
Date: Thu, 12 Sep 2013 14:26:53 -0500
Cc: Rob Herring <robherring2@gmail.com>, David Brown <davidb@codeaurora.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <584008C3-983C-4423-A76E-38DD67C2F1D9@codeaurora.org>
References: <1379003839-16068-1-git-send-email-galak@codeaurora.org> <CAOesGMisWLwYKotGDFPW6PyHJs=_+fohTdC08SGjsv2FXaa7Fg@mail.gmail.com> <25E0B143-658E-4CCC-A88A-0AF70FFF33CE@codeaurora.org> <CAOesGMhfdvyJ_2AA2e8iO_2e=q7KgpyNbcriPKFw-RLormG6bA@mail.gmail.com> <3E38F48E-EE41-4564-84A1-36CF07B08811@codeaurora.org> <CAOesGMhN0jEx065cpf989P-JbuxPiOaPRsP4BD3VoW-n5ebP+w@mail.gmail.com> <9DD9D9A7-ED55-412F-A18D-599D1E365003@codeaurora.org> <523205E1.2040704@gmail.com> <CAOesGMhSZzpyT5XyECByLnvef0E+92y+uaXByiG0Vpm9f05AxQ@mail.gmail.com>
To: Olof Johansson <olof@lixom.net>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 12, 2013, at 1:46 PM, Olof Johansson wrote:

> On Thu, Sep 12, 2013 at 11:20 AM, Rob Herring <robherring2@gmail.com> wrote:
> 
>> As Stephen W has pointed out previously, the dtb filename itself is or
>> may be an ABI and the bootloader may be hardcoded to a name. So we
>> should avoid future renames.
> 
> We still have the choice of producing the dtb files under
> arch/arm/boot/dts even if we move dts/dtsi files one level deeper, as
> long as we keep the filenames consistent. So we can do a move, just
> not a rename.


Looking at arch/arm/boot/dts/ we are all over the place, so what's the naming convention we are going forward with?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

