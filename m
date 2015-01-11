Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbbAKVkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:40:21 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35092 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbAKVkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:40:19 -0500
MIME-Version: 1.0
In-Reply-To: <1420818231-13451-8-git-send-email-soren.brinkmann@xilinx.com>
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
	<1420818231-13451-8-git-send-email-soren.brinkmann@xilinx.com>
Date: Sun, 11 Jan 2015 22:40:18 +0100
Message-ID: <CACRpkdbDEcStJhabgKEm8H=z2umEr+bd-0oK4_HvCO+rz0pTXQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] pinctrl: qcom-spmi-gpio: Migrate to pinconf-generic
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 4:43 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Instead of the driver caring about implementation details like device
> tree, just provide information about driver specific pinconf parameters
> to pinconf-generic which takes care of parsing the DT.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Patch applied: qualcomm folks, can you make sure that the Qualcomm
stuff is still working as expected with Sören's core parser?

Yours,
Linus Walleij
