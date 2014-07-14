Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaGNP6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:58:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52469 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaGNP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:58:33 -0400
Message-ID: <53C3FE0C.4080502@ti.com>
Date: Mon, 14 Jul 2014 10:58:04 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Markus Mayer <markus.mayer@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 0/5] OMAP Mailbox framework adoption & DT support
References: <1405116252-53612-1-git-send-email-s-anna@ti.com> <CAPdLdq=ZnPBQiGVbKOk8G5soP=uPYpT7mEjigpR=W1Hc4btV3g@mail.gmail.com>
In-Reply-To: <CAPdLdq=ZnPBQiGVbKOk8G5soP=uPYpT7mEjigpR=W1Hc4btV3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On 07/11/2014 06:15 PM, Markus Mayer wrote:
> On 11 July 2014 15:04, Suman Anna <s-anna@ti.com> wrote:
>> Hi,
>>
>> This is a refresh of the OMAP Mailbox framework adoption & DT support
>> series [1], to work with the revised OMAP mailbox DT/hwmod cleanup
>> series [2].
>>
>> The series has one less patch than the previous series, with the patch
>> "mailbox/omap: add a custom of_xlate function" squashed into the OMAP
>> mailbox framework adaptation patch. The first 3 patches deal with the
>> OMAP DT bindings and parse support like previous series, and the last
>> 2 patches deal with the mailbox framework adaptation. The testing is
>> also done with the updated v8 version of mailbox framework [3] from
>> Jassi Brar, no changes are required for the v7 to v8 update.
>>
>> The AM335 PM suspend series [4] which relies on this series also does
>> not require any changes.
> 
> May I ask what branch this series is based upon? I tried a number of
> branches (3.16-rcX, 3.15, linux-next), and the series won't apply to
> any of them (other than patch 1/5, which does apply fine, but that
> also contains no code).

There are couple of dependent preparatory series. You probably missed
the following in the cover letter.
> The series depends on the OMAP mailbox cleanup series [5] and the
> refreshed OMAP mailbox DT/hwmod cleanup series [2].

As long as you pick the two dependent series, they apply fine on any of
the 3.16-rcs. I have posted all the series based on 3.16-rc2. Here's a
merged branch for your reference (not for pulling though, it has one
additional commit to allow me to test on OMAP2)
https://github.com/sumananna/mailbox/commits/submit/3.16-rc2-omap-mbox-v8-fwk-v2

The last 2 patches in the series also depend on the mailbox framework
patches from Jassi to not throw any build errors if enabled.

regards
Suman
