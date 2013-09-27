Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3I0MRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:17:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48158 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3I0MRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <1377609965-22154-1-git-send-email-b.brezillon@overkiz.com>
References: <1377609965-22154-1-git-send-email-b.brezillon@overkiz.com>
Date: Fri, 27 Sep 2013 14:17:45 +0200
Message-ID: <CACRpkdY4z5Tn_3wO29c85vObOQAsKqbFLSR1kKn5twYbq+ULHw@mail.gmail.com>
Subject: Re: [PATCH] ARM: at91/at91-pinctrl documentation: add missing sam9x5
 compatible string
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
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

On Tue, Aug 27, 2013 at 3:26 PM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> Add missing "atmel,at91sam9x5-pinctrl" compatible string to the
> documentation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied with Nicolas' ACK.

Yours,
Linus Walleij
