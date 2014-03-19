Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708AbaCSQOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:14:45 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:46104 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964900AbaCSQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:14:44 -0400
MIME-Version: 1.0
In-Reply-To: <1395224808-10133-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395224808-10133-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Wed, 19 Mar 2014 11:14:43 -0500
Message-ID: <CAL_Jsq+sctq85ZhqKyVa7=r5A0FEDKu36692rRJufyca1gzF6g@mail.gmail.com>
Subject: Re: [PATCH] Documentation: dt: list all compatible strings for at91
From: Rob Herring <robherring2@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 5:26 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Avoids getting the newly introduced warning:
> WARNING: DT compatible string "atmel,at91sam9g45-adc" appears un-documented -- check ./Documentation/devicetree/bindings/
> +                               compatible = "atmel,at91sam9g45-adc";
>
> Introduced by:
> bff5da433525 checkpatch: add DT compatible string documentation checks

We should fix checkpatch instead. There are some fixes in progress,
but I don't think it covers this issue. I'm puzzled by this one as I
thought I checked for this case.

Rob
