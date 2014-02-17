Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaBQCi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 21:38:27 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:55739 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbaBQCiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 21:38:25 -0500
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Hunt, Joshua" <johunt@akamai.com>, stable <stable@vger.kernel.org>
Date: Sun, 16 Feb 2014 21:38:22 -0500
Subject: Re: [PATCH] printk: Fix discarding of records
Thread-Topic: [PATCH] printk: Fix discarding of records
Thread-Index: Ac8riVOjrlxvkJl1SRGf4JkhYGWY7Q==
Message-ID: <CF26C56A.2E864%dbanerje@akamai.com>
References: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
 <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
 <CF26B239.2E7B4%dbanerje@akamai.com>
 <CA+55aFyiEcMBegoypWVTZXnb4aLj1PD4FRHWV83X2DY=8VHz7w@mail.gmail.com>
 <CF26BC6D.2E80E%dbanerje@akamai.com>
 <CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
In-Reply-To: <CA+55aFyywOm7pWrX4=04LTEJ6xYK4xDTxGRqes-MOT212PnWPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/14, 7:41 PM, "Linus Torvalds" <torvalds@linux-foundation.org>
wrote:

>On Sun, Feb 16, 2014 at 4:19 PM, Banerjee, Debabrata
><dbanerje@akamai.com> wrote:
>>
>> No that can't be right, the prev value after every loop is the
>>msg->flags
>> from the *last* line in the list, which has no relation to the *first*,
>>so
>> reusing it for the top of the next loop is nonsense.
>
>Please, Debabrata, humor me, and just try the patch.
>
>And try reading the source code. Because your statement is BS.
...
>No, I haven't tested my patch, and maybe it's broken for some subtle
>reason I'm missing too.

Yes my explanation was wrong, your patch works for me. I assumed printing
the prefix was desired, but if not, great.

-Debabrata


