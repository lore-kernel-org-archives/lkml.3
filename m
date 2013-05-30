Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967847Ab3E3Hul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:50:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:25912 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967837Ab3E3Hua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:50:30 -0400
Message-ID: <51A704C3.6010109@atmel.com>
Date: Thu, 30 May 2013 09:50:27 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Robert Nelson <robertcnelson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johan Hovold <jhovold@gmail.com>
CC: Robert Nelson <Robert.Nelson@digikey.com>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com> <1369298335-24597-1-git-send-email-jhovold@gmail.com> <20130529133354.dd181c845ee4e96527483345@linux-foundation.org> <CAOCHtYiK8Y6iTnb4dWAE+cKHqEta-64gj+PorSFVGBF5wmg1+Q@mail.gmail.com>
In-Reply-To: <CAOCHtYiK8Y6iTnb4dWAE+cKHqEta-64gj+PorSFVGBF5wmg1+Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/2013 22:41, Robert Nelson :
> On Wed, May 29, 2013 at 3:33 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Thu, 23 May 2013 10:38:50 +0200 Johan Hovold <jhovold@gmail.com> wrote:
>>
>>> This is an update of the shadow-interrupt-mask series against v3.10-rc2.
>>>
>>> I guess we need Atmel to confirm that all sam9x5 SoCs are indeed
>>> affected. If not, then some probing mechanism as the one Doug suggested
>>> could be implemented on top of (a subset of) these patches. What do you
>>> say, Nicolas?
>>>
>>> Note that the first patch (adding a missing OF compile guard) could be
>>> applied straight away.
>>
>> At this stage it is unclear to me how to proceed with patches 2-5.
>
> fyi:
>
> A version of these patches had been applied once before:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0ef1594c017521ea89278e80fe3f80dafb17abde
>
> But due to a few issues it was later reverted:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e24b0bfa2f0446ffaad2661040be23668133aef8

This new revision doesn't have the issue encountered by first version.

Andrew,

The review of this patch series was in my TODO list for some time...

Today, I magically took time to review it ;-)
The patch series is good and I (even if it is too late) here is my:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I do not know if the series can be stacked for inclusion in 3.10-rc but 
the resolution of this bug can help a lot (as Douglas is saying in 
subsequent email...).

Best regards,
-- 
Nicolas Ferre
