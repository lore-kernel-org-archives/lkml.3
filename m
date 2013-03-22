Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3CVMrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:47:08 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:43435 "EHLO mailhub2.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893Ab3CVMrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:47:04 -0400
Message-ID: <514C4B1A.50609@c-s.fr>
Date: Fri, 22 Mar 2013 13:14:18 +0100
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Patrick Vasseur <patrick.vasseur@c-s.fr>
Subject: Re: [PATCH v2] Adds support for Open Firmware in MAX730x GPIO Driver
References: <201303051526.r25FQoCv002950@localhost.localdomain> <CACRpkdaETvQmEWSSp-Vj1tu-KVPBgWrKbMZbgTjmRt=7Yxxg6g@mail.gmail.com>
In-Reply-To: <CACRpkdaETvQmEWSSp-Vj1tu-KVPBgWrKbMZbgTjmRt=7Yxxg6g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 130322-0, 22/03/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/03/2013 09:38, Linus Walleij a écrit :
> On Tue, Mar 5, 2013 at 4:26 PM, Christophe Leroy
> <christophe.leroy@c-s.fr> wrote:
>
>> This patch allows the use of the MAX730x Driver on systems using
>> the Open Firmware platform format.
>> The bit_per_word can be set in the OF Device tree, so no need to force it as with
>> the platform_data.
>>
>> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> I tried applying this but it fails. Can you send based on e.g.
> v3.9-rc3 or so?
Ok, part of it was already in 3.8
Made a new one based on 3.8.4
I checked it against 3.9-rc3, it is OK
NB: I changed the patch subject name

Regards
Christophe

