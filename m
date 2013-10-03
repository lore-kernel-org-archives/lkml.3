Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3JCI0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:26:44 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42520 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3JCI0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <524D296B.2090905@overkiz.com>
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com>
 <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com>
 <CAHkwnC_Q5XVcb5m5gZuG+s7ojgBb6b29pW9_rENA1sBjo4+-7Q@mail.gmail.com> <524D296B.2090905@overkiz.com>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Thu, 3 Oct 2013 10:26:20 +0200
Message-ID: <CAHkwnC_99j4Xu0mezA=8c5mdVj9E_c2BK-gaZcBp6vPzG9euOg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] watchdog: at91sam9_wdt: update device tree doc
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 10:23 AM, boris brezillon
<b.brezillon@overkiz.com> wrote:
> Hello Fabio,
>
>
> On 03/10/2013 10:08, Fabio Porcedda wrote:
>>
>> On Fri, Jun 21, 2013 at 9:23 AM, Boris BREZILLON
>> <b.brezillon@overkiz.com> wrote:
>>>
>>> Add new at91sam9 watchdog properties to the documentation.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> ---
>>>   .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30
>>> ++++++++++++++++++--
>>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>>> b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>>> index fcdd48f..e043106 100644
>>> --- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>>> +++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>>> @@ -9,11 +9,37 @@ Required properties:
>>>
>>>   Optional properties:
>>>   - timeout-sec: contains the watchdog timeout in seconds.
>>
>> Why are you removing the documentation about this property?
>
>
> I'm not removing the property: this is an enumeration minus not a diff
> minus.

Good, sorry for the noisy.

Best regards
-- 
Fabio Porcedda
