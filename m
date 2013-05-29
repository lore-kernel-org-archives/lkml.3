Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967011Ab3E2UlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:41:24 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:45020 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966857Ab3E2UlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130529133354.dd181c845ee4e96527483345@linux-foundation.org>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
	<1369298335-24597-1-git-send-email-jhovold@gmail.com>
	<20130529133354.dd181c845ee4e96527483345@linux-foundation.org>
Date: Wed, 29 May 2013 15:41:02 -0500
Message-ID: <CAOCHtYiK8Y6iTnb4dWAE+cKHqEta-64gj+PorSFVGBF5wmg1+Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
From: Robert Nelson <robertcnelson@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Robert Nelson <Robert.Nelson@digikey.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 3:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 23 May 2013 10:38:50 +0200 Johan Hovold <jhovold@gmail.com> wrote:
>
>> This is an update of the shadow-interrupt-mask series against v3.10-rc2.
>>
>> I guess we need Atmel to confirm that all sam9x5 SoCs are indeed
>> affected. If not, then some probing mechanism as the one Doug suggested
>> could be implemented on top of (a subset of) these patches. What do you
>> say, Nicolas?
>>
>> Note that the first patch (adding a missing OF compile guard) could be
>> applied straight away.
>
> At this stage it is unclear to me how to proceed with patches 2-5.

fyi:

A version of these patches had been applied once before:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0ef1594c017521ea89278e80fe3f80dafb17abde

But due to a few issues it was later reverted:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e24b0bfa2f0446ffaad2661040be23668133aef8

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
