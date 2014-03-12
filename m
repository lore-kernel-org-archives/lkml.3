Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaCLRtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:49:00 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55233 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbaCLRs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:48:58 -0400
Message-ID: <53209E04.1010509@mev.co.uk>
Date: Wed, 12 Mar 2014 17:48:52 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Fred Akers <knivey@botops.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] Staging: comedi: addi-data: Fix long CamelCase
 function names
References: <1394350009-23464-1-git-send-email-knivey@botops.net> <1394576353-25247-1-git-send-email-knivey@botops.net> <DC148C5AA1CEBA4E87973D432B1C2D8825DADED5@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825DADED5@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-12 01:06, Hartley Sweeten wrote:
> On Tuesday, March 11, 2014 3:19 PM, Fred Akers wrote:
>> This patch fixes a few function names that are very long and are
>> not in the correct naming style
>>
>> Signed-off-by: Fred Akers <knivey@botops.net>
>
> Fred,
>
> I pulled Greg's staging tree to see if your patches apply.
>
> Patch 1/2 is ok but patch 2/2 does not apply:
>
> Applying: Staging: Comedi: addi-data: Clean up function comments
> error: patch failed: drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c:1
> error: drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c: patch does not apply
> error: patch failed: drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c:1
> error: drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c: patch does not apply
> error: patch failed: drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:1
> error: drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: patch does not apply
> Patch failed at 0001 Staging: Comedi: addi-data: Clean up function comments
>
> Maybe Greg will have better luck.
>
> Regards,
> Hartley
>

FWIW, I managed to apply them, but mainly because our internal MS 
Exchange server (which often messes up patches) is down, so I'm having 
to deliver the mail to a "proper" mail server. :)

(Also, the patches in the driverdev-devel archive don't apply as-is, 
partly because it replaces '@' with ' at ', and partly because it 
replaces the ezsett character in 'Dieselstraﬂe' with a question mark '?'.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

