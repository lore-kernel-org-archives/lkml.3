Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbaDJQIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:08:07 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:41477 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934689AbaDJQH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <1396302597-31801-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1396302597-31801-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Thu, 10 Apr 2014 18:07:58 +0200
Message-ID: <CACRpkdb3DD4r97jJbMV9d9=eZxFU8zSXu1eAGsM=ax+ebFDZ8g@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: msm: Correct interrupt code for TLMM v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:49 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> Acking interrupts are done differently between on v2 and v3, so add an extra
> attribute to the pingroup struct to let the platform definitions control this.
> Also make sure to start dual edge detection by detecting the rising edge.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Patch applied for fixes. Sorry for the delay.

Yours,
Linus Walleij
