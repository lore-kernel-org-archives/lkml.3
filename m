Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKZVH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:07:56 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:59804 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141126183052.GH3443@lunn.ch>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
 <1417023640-23464-3-git-send-email-leif.lindholm@linaro.org> <20141126183052.GH3443@lunn.ch>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 26 Nov 2014 21:07:33 +0000
X-Google-Sender-Auth: iXDE9dgM1aTtQMtjc9EHbQa3yDg
Message-ID: <CACxGe6tYZ8aE_TKw1cYMY5DDjpSXPSnhhAam-rG5NgdjpKJe+A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] of: support passing console options with stdout-path
To: Andrew Lunn <andrew@lunn.ch>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ian Campbell <ijc@debian.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 6:30 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> On Wed, Nov 26, 2014 at 05:40:40PM +0000, Leif Lindholm wrote:
>> Support specifying console options (like with console=ttyXN,<options>)
>> by appending them to the stdout-path property after a separating ':'.
>>
>> Example:
>>         stdout-path = "uart0:115200";
>
> Hi Leif
>
> This should be documented somewhere under
> Documentation/devicetree/bindings/
>
> Not sure where thought. Maybe a top level chosen.txt?

Actually, this one doesn't. It is already documented in ePAPR

g.
