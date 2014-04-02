Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaDBOOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:14:50 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:54203 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932120AbaDBOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:14:49 -0400
Message-ID: <533C1B53.8070506@codethink.co.uk>
Date: Wed, 02 Apr 2014 15:14:43 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>,
        Shawn Guo <shawn.guo@linaro.org>
CC: kernel@pengutronix.de, linux@arm.linux.org.uk,
        CHAUMETTE Hubert <hchaumette@adeneo-embedded.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
References: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com> <20140321222320.14370739@e6520eb> <1762157698.5689069.1395675049240.JavaMail.zimbra@adeneo-embedded.com> <20140324164141.51b85f8c@e6520eb> <20140402131404.GE8558@dragon> <20140402153855.237e7a50@e6520eb>
In-Reply-To: <20140402153855.237e7a50@e6520eb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/14 14:38, Eric Bénard wrote:
> Hi Shawn,
>
> Le Wed, 2 Apr 2014 21:14:08 +0800,
> Shawn Guo <shawn.guo@linaro.org> a écrit :
>
>>
>> On Mon, Mar 24, 2014 at 04:41:41PM +0100, Eric Bénard wrote:
>>> Hi Hubert,
>>>
>>> Le Mon, 24 Mar 2014 16:30:49 +0100 (CET),
>>> CHAUMETTE Hubert <hchaumette@adeneo-embedded.com> a écrit :
>>>>> From: "Eric Bénard" <eric@eukrea.com>
>>>>> that's board specific (the needed delay depends on the routing delay on
>>>>> the PCB), so this should not go in a generic file.
>>>>>
>>>>> Eric
>>>>>
>>>>
>>>> I admit it may need to be in a separate function, but this file already contains
>>>> board-specific fixups (for imx6q sabrelite, Data Modul eDM-QMX6).
>>>>
>>> true but that's not a reason to add more ;-)
>>>
>>>> Anyway, do you have any suggestion for the location I should put it ?
>>>>
>>> no idea at the moment, I simply used your patch to bring this issue on
>>> the ML as we recently needed to patch the default values for testing
>>> mainline kernel on a custom boards.
>>
>> Hmm, can such board-specific fixups be pushed down to bootloader?
>>
> that won't work if the kernel reset the PHY.

If it is in device-tree, then you can add it to the phy node.

For earlier Micrel Phys we have a LED mode setting on initialisaion.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
