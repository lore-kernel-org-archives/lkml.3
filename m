Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbaJaKQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:16:35 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:58173 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbaJaKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <1414171020-15706-1-git-send-email-jcmvbkbc@gmail.com>
References: <1414171020-15706-1-git-send-email-jcmvbkbc@gmail.com>
Date: Fri, 31 Oct 2014 13:16:33 +0300
Message-ID: <CAMo8BfLbn-gMNtPYKP-9VvJUgyhoSp6d06a0vdw=SgOCS9CNWw@mail.gmail.com>
Subject: Re: [PATCH] clk: TI CDCE706 clock synthesizer driver
From: Max Filippov <jcmvbkbc@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 8:17 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> The driver allows using CDCE706 in its default configuration recorded in
> EEPROM and adjusting of synthesized clocks by consumers.
>
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  .../devicetree/bindings/clock/ti,cdce706.txt       |  16 +
>  MAINTAINERS                                        |   5 +
>  drivers/clk/Kconfig                                |   8 +
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-cdce706.c                          | 700 +++++++++++++++++++++
>  5 files changed, 730 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/ti,cdce706.txt
>  create mode 100644 drivers/clk/clk-cdce706.c

Ping?

-- 
Thanks.
-- Max
