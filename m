Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbbAKVlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:41:32 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61940 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbAKVla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:41:30 -0500
MIME-Version: 1.0
In-Reply-To: <b987f31220ab424285e27200bb187158@BY2FFO11FD012.protection.gbl>
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
	<b987f31220ab424285e27200bb187158@BY2FFO11FD012.protection.gbl>
Date: Sun, 11 Jan 2015 22:41:29 +0100
Message-ID: <CACRpkdYLHOHhSYSJZcggmATnMRg_7Pq8-fF3c2MJW9E69DiqJg@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] pinctrl support for Zynq
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
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
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 5:53 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Fri, 2015-01-09 at 07:43AM -0800, Soren Brinkmann wrote:
>> Hi Linus,
>>
>> I rebased my branch onto your current pinctrl/devel. Other than that
>> this should be exactly what has been sent out as v3. This time I'll use
>> the gmail SMTP again, which hopefully resolves the encoding issue.
>
> The transfer-encoding is again 'quoted-printable'. So, seems it is not
> exchange to blame. I tried to git am a patch from this series and it
> seems to work fine. I.e. send-email and am apparently to the right
> thing.

Yeah it works like a charm :)

All patches that affect the pin control tree are applied now. It is
looking *beautiful* especially your device trees look exactly as I
want them to look for a group/function type pin controller driver.

Yours,
Linus Walleij
