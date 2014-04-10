Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935479AbaDJQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:09:57 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36297 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934689AbaDJQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <1396302597-31801-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1396302597-31801-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Thu, 10 Apr 2014 18:09:53 +0200
Message-ID: <CACRpkdaS7s44Szpu5eUVc-_DEDiGqer6FWc2VK-OUxTO4p-QKg@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: msm: Make number of functions variable
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

> The various pins may have different number of functions defined, so make this
> number definable per pin instead of just increasing it to the largest one for
> all of the platforms.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Patch applied for next (v3.16)

Yours,
Linus Walleij
