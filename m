Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3BLWnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:43:52 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58986 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3BLWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:43:50 -0500
Message-ID: <511AC5A8.4030509@linaro.org>
Date: Tue, 12 Feb 2013 23:43:52 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 14/16] intel_idle: remove use and definition of MWAIT_MAX_NUM_CSTATES
References: <1360372100-28482-1-git-send-email-lenb@kernel.org> <137ecc779c80138723677209730738d76262e810.1360371180.git.len.brown@intel.com> <5118B16E.6010709@linaro.org> <511982C6.7080505@kernel.org>
In-Reply-To: <511982C6.7080505@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 12:46 AM, Len Brown wrote:
> On 02/11/2013 03:53 AM, Daniel Lezcano wrote:
>> On 02/09/2013 02:08 AM, Len Brown wrote:
> 
>>> The reason to change is that intel_idle will soon be able
>>> to export more than the 8 "major" states supported by MWAIT.
>>> When we hit that limit, it is important to know
>>> where the limit comes from.
>>
>> Does it mean CPUIDLE_STATE_MAX may increase in a near future ?
> 
> Yes, perhaps to 10.
> Let me know if you anticipate issues with doing that.

No, I don't see any issue so far. Maybe the array state is increasing
more and more, so for most architecture it is a waste of memory, but
anyway ...



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

