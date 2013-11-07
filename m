Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3KGUQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:16:21 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:32958 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3KGUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131107201332.GA7119@katana>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
	<1381960909-1735-3-git-send-email-tim.kryger@linaro.org>
	<20131101130835.GC6734@katana>
	<CAAYSxhrrkSvOJpYPz7txVsot1you3fFzkXJ6fqaS4OgRM0Z2gA@mail.gmail.com>
	<20131107201332.GA7119@katana>
Date: Thu, 7 Nov 2013 12:16:11 -0800
Message-ID: <CAAYSxhp6bY==tyHXCUz4zYVS+Nc=hDBscf_QBrkxwY28AOA=ig@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/4] i2c: i2c-bcm-kona: Add support for high-speed mode
From: Tim Kryger <tim.kryger@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 12:13 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> OK. Then please change the error message for unsupported bus speeds to
> contain the supported ones. I don't think it is good practice to force
> users to look into the sourcecode to find this information.

That works for me.  Thanks.

-Tim
