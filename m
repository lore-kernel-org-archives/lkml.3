Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaGILra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:47:30 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51437 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGILr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <1404881971-10341-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1404881971-10341-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Wed, 9 Jul 2014 13:47:27 +0200
Message-ID: <CACRpkdbuTp1RuejHTtpcLFcgFryiyu=q3qFXGLvY0eXKiZ=+ng@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: msm: Add msm8960 definitions
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andreas Frber <afaerber@suse.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 6:59 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>
> Changes since v2:

This v3 version applied.

BTW: does this cover the 8660 too or does that chip need a separate
subdriver? I'm told that the second digit in qualcomm numbers is
"just" about the modem version, but I guess that can affect the pinout.

Yours,
Linus Walleij
