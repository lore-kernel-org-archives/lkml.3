Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbaFLIqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:46:17 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56999 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbaFLIqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <5390F5C7.5070301@wwwdotorg.org>
References: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com>
	<1401894990-30092-2-git-send-email-thierry.reding@gmail.com>
	<53909F31.4050603@wwwdotorg.org>
	<20140605220833.GA28817@ulmo>
	<5390F5C7.5070301@wwwdotorg.org>
Date: Thu, 12 Jun 2014 10:46:13 +0200
Message-ID: <CACRpkdZxS3UKaykTXsaGADCWmvfpAW_nhbxYHLSh44HMXLWvCg@mail.gmail.com>
Subject: Re: [PATCH 2/4] of: Add NVIDIA Tegra XUSB pad controller binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 12:57 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> In my opinion, the headers *are*
> part of the bindings, so of course anyone either reading DT bindings, or
> parsing DT, must have the headers, and hence the headers must be bundled
> with the DT files or with the bindings wherever they go.

I agree 100% with Stephen's stance. Reference the headers.

Yours,
Linus Walleij
