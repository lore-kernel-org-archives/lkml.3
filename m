Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3LTIoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:44:12 -0500
Received: from 13.mo3.mail-out.ovh.net ([188.165.33.202]:57942 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754782Ab3LTIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:44:11 -0500
X-Greylist: delayed 55843 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 03:44:11 EST
Message-ID: <52B400F3.2020409@overkiz.com>
Date: Fri, 20 Dec 2013 09:33:55 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] gpio: add missing word in gpio dt binding doc
References: <1387462890-675-1-git-send-email-b.brezillon@overkiz.com> <20131219191315.GP8064@book.gsilab.sittig.org>
In-Reply-To: <20131219191315.GP8064@book.gsilab.sittig.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 74872344378636386
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/2013 20:13, Gerhard Sittig wrote:
> On Thu, Dec 19, 2013 at 15:21 +0100, Boris BREZILLON wrote:
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   Documentation/devicetree/bindings/gpio/gpio.txt |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
>> index e2295e3..4019ce1 100644
>> --- a/Documentation/devicetree/bindings/gpio/gpio.txt
>> +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
>> @@ -56,7 +56,7 @@ and empty GPIO flags as accepted by the "qe_pio_e" gpio-controller.
>>   2) gpio-controller nodes
>>   ------------------------
>>   
>> -Every GPIO controller node must both an empty "gpio-controller"
>> +Every GPIO controller node must contain both an empty "gpio-controller"
>>   property, and have #gpio-cells contain the size of the gpio-specifier.
>>   
>>   It might contain GPIO hog definitions. GPIO hogging is a mechanism providing
>> -- 
>> 1.7.9.5
> The context of the patch appears to contain stuff that gets
> introduced with the RFC patch you sent out after this one.  If
> this suspicion(sp?) is true, you may have to re-create the patch
> on top of something official.

Ooops. Your suspicions were true ;-).
I'll send a new patch based on a clean context.

Best Regards,

Boris
> :)  And you may want to mark this
> patch as "trivial".
>
>
> virtually yours
> Gerhard Sittig

