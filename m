Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbaGBTij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:38:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39224 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921AbaGBTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:38:36 -0400
Message-ID: <53B45F9C.2040209@ti.com>
Date: Wed, 2 Jul 2014 14:38:04 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv5 06/15] hwspinlock/omap: enable module before reading
 SYSSTATUS register
References: <1398904476-26200-1-git-send-email-s-anna@ti.com> <1398904476-26200-7-git-send-email-s-anna@ti.com> <CAK=WgbaKPgLLw-4wCSToE86QrREDB0sK95TLx2y17d71eBPFbg@mail.gmail.com>
In-Reply-To: <CAK=WgbaKPgLLw-4wCSToE86QrREDB0sK95TLx2y17d71eBPFbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 07/01/2014 07:51 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Thu, May 1, 2014 at 3:34 AM, Suman Anna <s-anna@ti.com> wrote:
>> The number of hwspinlocks are determined based on the value read
>> from the IP block's SYSSTATUS register. However, the module may
>> not be enabled and clocked, and the read may result in a bus error.
>>
>> This particular issue is seen rather easily on AM33XX, since the
>> module wakeup is software controlled, and it is disabled out of
>> reset. Make sure the module is enabled and clocked before reading
>> the SYSSTATUS register.
> 
> This seems like a valid fix that is independent of this patch series.
> 
> Feel free to submit it separately if you want, so we can get it merged.
> 

OK, I will submit this patch and Patch 7 separately.

regards
Suman


