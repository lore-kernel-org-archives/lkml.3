Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3FDJDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:03:43 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63595 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3FDJDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <1369920465-13905-5-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
	<1369920465-13905-5-git-send-email-fabio.baltieri@linaro.org>
Date: Tue, 4 Jun 2013 11:03:41 +0200
Message-ID: <CACRpkda8h_zewd2M7QzvoLn15iDEUv8XYCGqro62chiCcYaM8Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: ux500: Provide auxdata to ux500 ASoC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 3:27 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Ux500 ASoC driver is expected to have a specific device name to get
> clock resources correctly.  This patch provides the necessary
> OF_DEV_AUXDATA to match the name in DT and non-DT cases.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Patch applied to my ux500-devicetree branch after some rebasing.

Yours,
Linus Walleij
