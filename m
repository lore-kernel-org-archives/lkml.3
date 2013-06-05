Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3FEFZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:25:39 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64335 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3FEFZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:25:35 -0400
MIME-Version: 1.0
In-Reply-To: <1369145282-14419-4-git-send-email-prakash.pm@ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
	<1369145282-14419-4-git-send-email-prakash.pm@ti.com>
Date: Wed, 5 Jun 2013 13:25:35 +0800
Message-ID: <CAN1soZx+xYJT24XZqoynFJj3wjTuq14S6dtpd=SFw5_iDWTiWw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: pinctrl-single: pin names for pinctrl-single.bits
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: Walleij Linus <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        grant.likely@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Linux Russell <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Tony Lindgren <tony@atomide.com>, prabhakar.csengg@gmail.com,
        peter.ujfalusi@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:08 PM, Manjunathappa, Prakash
<prakash.pm@ti.com> wrote:
> Take care to name pin names as
> register-offset.bit-pos-of-pin-in-register in case configuring multiple
> pins in register.
>
> Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> ---

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
