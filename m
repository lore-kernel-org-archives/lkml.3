Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3HPMEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:04:34 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:58915 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3HPMEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <520B8B45.1010300@baylibre.com>
References: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
	<520B8B45.1010300@baylibre.com>
Date: Fri, 16 Aug 2013 15:04:29 +0300
X-Google-Sender-Auth: tqLNaR0ZSoWI8KazD-btzZVSBBA
Message-ID: <CAB=otbTUk68CLmgQsEoefMMFTAnZCAMbZa-yiYmn1b3F1X8BiQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] omap4/twl6030: typical connection to omap4 as a
 separate dtsi file
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
Cc: linux-omap <linux-omap@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uri.y@variscite.com, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Wed, Aug 14, 2013 at 4:51 PM, Benoit Cousson <bcousson@baylibre.com> wrote:
> Hi Ruslan,
>
> On 14/08/2013 10:35, Ruslan Bilovol wrote:
>>
>> Hello,
>>
>> There is no functional changes between v1 and v2 - just
>> added the patch for omap4-var-som - Uri Yosef confirmed
>> this board have the same connection of OMAP4<->TWL6030 as
>> SDP4430 board
>
>
> The series looks good to me, but it will be good to have a test for Panda
> and Variscite boards before merging it.

Okay, so I just verified this patch series on PandaBoard ES2. Should I
resubmit this series with
fixed commit message?
However I cannot verify the patch for Variscite board because I do not
own any such board so
you can drop that patch. But maybe Uri Yosef can verify it. Uri?

>
> Regards,
> Benoit

-- 
Best regards,
Ruslan Bilvol
