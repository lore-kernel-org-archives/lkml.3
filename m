Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3HSGOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:14:34 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64519 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3HSGOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <520E2726.304@baylibre.com>
References: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
	<520B8B45.1010300@baylibre.com>
	<CAB=otbTUk68CLmgQsEoefMMFTAnZCAMbZa-yiYmn1b3F1X8BiQ@mail.gmail.com>
	<520E2726.304@baylibre.com>
Date: Mon, 19 Aug 2013 09:14:29 +0300
X-Google-Sender-Auth: dua36wq8PsHDw_ceSRx6fsNpA0c
Message-ID: <CAB=otbRLea7V6_4Rhfr=ApNV=+2sQXnY=JW9-vy6V+hbt336wg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] omap4/twl6030: typical connection to omap4 as a
 separate dtsi file
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
Cc: Nishanth Menon <nm@ti.com>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uri.y@variscite.com, linux-omap <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Fri, Aug 16, 2013 at 4:20 PM, Benoit Cousson <bcousson@baylibre.com> wrote:
> Hi Ruslan,
>
> On 16/08/2013 14:04, Ruslan Bilovol wrote:
>> Hi Benoit,
>>
>> On Wed, Aug 14, 2013 at 4:51 PM, Benoit Cousson <bcousson@baylibre.com> wrote:
>>> Hi Ruslan,
>>>
>>> On 14/08/2013 10:35, Ruslan Bilovol wrote:
>>>>
>>>> Hello,
>>>>
>>>> There is no functional changes between v1 and v2 - just
>>>> added the patch for omap4-var-som - Uri Yosef confirmed
>>>> this board have the same connection of OMAP4<->TWL6030 as
>>>> SDP4430 board
>>>
>>>
>>> The series looks good to me, but it will be good to have a test for Panda
>>> and Variscite boards before merging it.
>>
>> Okay, so I just verified this patch series on PandaBoard ES2. Should I
>> resubmit this series with
>> fixed commit message?
>
> No, that's fine, I already applied it and fixed the subject and the changelog.
>
> Here it is:
>
> commit 2e25df1e5a4af906a9b25332719ace000063eb0d
> Author: Ruslan Bilovol <ruslan.bilovol@ti.com>
> Date:   Wed Aug 14 11:35:47 2013 +0300
>
>     ARM: dts: twl6030: Move common configuration for OMAP4 boards in a separate dtsi file
>
>     The OMAP4 SoC family uses specially-designed PMIC (power management IC)
>     companion chip for power management needs: TWL6030/TWL6032.
>     Therefore there is a typical connection of PMIC to OMAP4 so we can
>     move it into separate .dtsi file and do not duplicate over
>     board-specific files.
>
>     Tested on OMAP4 SDP board and compile-tested for Panda board

Just for archives: I've successfully tested it on PandaBoard ES2 last
week as well.

>
>     Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
>     Signed-off-by: Benoit Cousson <bcousson@baylibre.com>
>
>
> Just let me know if you are OK with the updated version.

Yes, this version looks good to me. Thanks for picking it up!

>
>> However I cannot verify the patch for Variscite board because I do not
>> own any such board so
>> you can drop that patch. But maybe Uri Yosef can verify it. Uri?
>
> It seems that Uri cannot test it right now, so I will have to drop that one.

Okay, let's wait for Uri's verification.

Best regards,
Ruslan

>
> Thanks,
> Benoit
>
>
