Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3LPJdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:33:17 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41207 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3LPJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:33:13 -0500
MIME-Version: 1.0
In-Reply-To: <1387090914-4755-4-git-send-email-bjorn.andersson@sonymobile.com>
References: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1387090914-4755-4-git-send-email-bjorn.andersson@sonymobile.com>
Date: Mon, 16 Dec 2013 10:33:13 +0100
Message-ID: <CACRpkdav+9+DUYA1V6hK94Xag0LbrN=Zw6q=RmbmFsu8EN3-2A@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl-msm: Remove separate allocation of bitmaps
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 8:01 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> Make the bitmaps part of the msm_pinctrl allocation instead of
> separately allocating them.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Patch applied.

Yours,
Linus Walleij
