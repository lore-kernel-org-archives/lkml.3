Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3ILSqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:46:36 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:42624 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3ILSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:46:34 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <523205E1.2040704@gmail.com>
References: <1379003839-16068-1-git-send-email-galak@codeaurora.org>
	<CAOesGMisWLwYKotGDFPW6PyHJs=_+fohTdC08SGjsv2FXaa7Fg@mail.gmail.com>
	<25E0B143-658E-4CCC-A88A-0AF70FFF33CE@codeaurora.org>
	<CAOesGMhfdvyJ_2AA2e8iO_2e=q7KgpyNbcriPKFw-RLormG6bA@mail.gmail.com>
	<3E38F48E-EE41-4564-84A1-36CF07B08811@codeaurora.org>
	<CAOesGMhN0jEx065cpf989P-JbuxPiOaPRsP4BD3VoW-n5ebP+w@mail.gmail.com>
	<9DD9D9A7-ED55-412F-A18D-599D1E365003@codeaurora.org>
	<523205E1.2040704@gmail.com>
Date: Thu, 12 Sep 2013 11:46:33 -0700
Message-ID: <CAOesGMhSZzpyT5XyECByLnvef0E+92y+uaXByiG0Vpm9f05AxQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:20 AM, Rob Herring <robherring2@gmail.com> wrote:

> As Stephen W has pointed out previously, the dtb filename itself is or
> may be an ABI and the bootloader may be hardcoded to a name. So we
> should avoid future renames.

We still have the choice of producing the dtb files under
arch/arm/boot/dts even if we move dts/dtsi files one level deeper, as
long as we keep the filenames consistent. So we can do a move, just
not a rename.


-Olof
