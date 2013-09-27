Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3I0MK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:10:27 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58069 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3I0MKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <1379058333-3286-1-git-send-email-b.brezillon@overkiz.com>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
	<1379058333-3286-1-git-send-email-b.brezillon@overkiz.com>
Date: Fri, 27 Sep 2013 14:10:24 +0200
Message-ID: <CACRpkdaiKujDwQYEP-uiYFth2xcJoF6Xx_8ts+HFYiOagNMXiw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] pinctrl: at91: fix typos
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 9:45 AM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> Fix AT91_PINCTRL_DEBOUNCE_VAL dt macro typo.
> Fix at91_pinctrl_mux_ops callback typos.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied with Jean-Christophe's ACK.

Yours,
Linus Walleij
