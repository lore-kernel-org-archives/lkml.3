Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327Ab3BMUiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:38:25 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:42335 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934006Ab3BMUiW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:38:22 -0500
From: Loic PALLARDY <loic.pallardy@st.com>
To: "Anna, Suman" <s-anna@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>
Date: Wed, 13 Feb 2013 21:36:39 +0100
Subject: Re: [PATCH v2 00/13] drivers: mailbox: framework creation
Thread-Topic: [PATCH v2 00/13] drivers: mailbox: framework creation
Thread-Index: Ac4KKdO/yUHXCgROS4mU7OXPLtfQ3w==
Message-ID: <511BF957.4010501@st.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
 <CACRpkdZayg-X11ZRnh2Z0i+egBn8Fhwya-6_Yr8wcv+6s0CVqQ@mail.gmail.com>
 <20130213134207.GN17852@n2100.arm.linux.org.uk>
 <37C860A02101E749A747FA2D3C1E3C50476638@DLEE12.ent.ti.com>
In-Reply-To: <37C860A02101E749A747FA2D3C1E3C50476638@DLEE12.ent.ti.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

I'll send new version of patch 11 taking into account Mark Rutland's 
comments.

Regards,
Loic

On 02/13/2013 05:41 PM, Anna, Suman wrote:
>> On Wed, Feb 13, 2013 at 02:36:32PM +0100, Linus Walleij wrote:
>>> On Tue, Feb 12, 2013 at 5:56 AM, Suman Anna<s-anna@ti.com>  wrote:
>>>
>>>> I have hosted the series at [3].
>>>> [3]
>>>> https://github.com/sumananna/mailbox/commits/dbx500-prcmu-mailbox
>>>
>>> Suman, I suggest you ask Stepgen Rothwell to include this branch into
>>> the linux-next tree, so we can get some rotation of this stuff in
>>> preparation for the v3.10 merge window. (It's not going in now
>>> anyway.)
>>
>> Best wait until after v3.9-rc1 - remember that linux-next is supposed to be a
>> staging tree for the _next_ merge window only.
>
> Yes, will do. Anyway, we need a new revision of one patch (so far) to address Mark Rutland's comments.
>
> Thanks
> Suman