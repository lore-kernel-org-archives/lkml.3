Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaC1Vv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:51:59 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55942 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaC1Vv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:51:56 -0400
MIME-Version: 1.0
In-Reply-To: <1395933906-2268-2-git-send-email-harinik@xilinx.com>
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
	<1395933906-2268-2-git-send-email-harinik@xilinx.com>
Date: Fri, 28 Mar 2014 22:51:56 +0100
Message-ID: <CACRpkdZ+cSz=NZpuzY8ER0d1+pwBdcGs=0BqY5jrG6k6At_RQA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Devicetree: Add Zynq GPIO devicetree bindings documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        michals@xilinx.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 4:25 PM, Harini Katakam <harinik@xilinx.com> wrote:

> Add gpio-zynq bindings documentation.
>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>

No comments really, but you should create one instance per
bank I think.

Yours,
Linus Walleij
