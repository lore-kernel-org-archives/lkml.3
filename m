Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbaDIHHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:07:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:46459 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191AbaDIHH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,824,1389772800"; 
   d="scan'208";a="517276532"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>, Daniel J Blueman <daniel@quora.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] i915 DVI resolution regression (3.13.7+)
In-Reply-To: <CAPM=9tz+xo7vktTZ=8QB6rMGPnTXd485wbwaq_4Ao9fGEnh4hQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com> <878urg9ttv.fsf@intel.com> <CAMVG2suG7ysnci25Cy_+fzvQ8r_R9O2nCuVZf=Zw9t5ZvEOSLQ@mail.gmail.com> <CAPM=9tyKKn5VrQkwGY2kEVBatSTN5VqJCVXWqFhn4oDe=oqsqA@mail.gmail.com> <CAMVG2stTR=qadOYTMaCnGwLv6pUF9R2VeNVdhnRTw6Gki=FNHA@mail.gmail.com> <CAPM=9tz+xo7vktTZ=8QB6rMGPnTXd485wbwaq_4Ao9fGEnh4hQ@mail.gmail.com>
User-Agent: Notmuch/0.17+162~g34940eaa1d37 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Apr 2014 10:08:04 +0300
Message-ID: <87lhvf7zfv.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014, Dave Airlie <airlied@gmail.com> wrote:
> On Wed, Apr 9, 2014 at 4:07 PM, Daniel J Blueman <daniel@quora.org> wrote:
>> On 9 April 2014 11:41, Dave Airlie <airlied@gmail.com> wrote:
>>> On Tue, Apr 8, 2014 at 5:32 PM, Daniel J Blueman <daniel@quora.org> wrote:
>>>> On 8 April 2014 15:14, Jani Nikula <jani.nikula@linux.intel.com> wrote:
>>>>> On Tue, 08 Apr 2014, Daniel J Blueman <daniel@quora.org> wrote:
>>>>>> Ville et al,
>>>>>>
>>>>>> It looks like commit e3ea8fa6beaf55fee64bf816f3b8a80ad733b2c2 (or
>>>>>> another commit in 3.13.7) broke modes which require DVI-D dual-link,
>>>>>> eg 2560x1440 with my panel.
>>>>>>
>>>>>> I don't see these modelines in 3.13.7 or later (eg 3.14):
>>>>>>
>>>>>> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
>>>>>> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
>>>>>> [     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
>>>>>> 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
>>>>>> [     5.582] (II) intel(0): Modeline "1920x1200"x59.9  193.25  1920
>>>>>> 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)
>>>>>>
>>>>>> My monitor is a Dell U2713HM; mobo uses an H87 chipset with i5-4670.
>>>>>
>>>>> By allowing those modes we regressed setups which were not capable of
>>>>> displaying them. So you've got an HDMI->DVI converter?
>>>>>
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=72961
>>>>
>>>> I am using a dual-link DVI-D to DVI-D cable to this monitor, since I
>>>> previously couldn't get 2560x1440 via HDMI.
>>>
>>> Intel hw has dual-link DVI-D? I'm not sure I've ever seen that, is
>>> this SDVO device or plain DVI-D?
>>
>> It's the DVI-D connector on: https://www.asus.com/Motherboards/H87IPLUS/
>
> The link which says "
>
> Integrated Graphics Processor
> - Supports HDMI with max. resolution 4096 x 2304 @ 24 Hz
> - Supports DVI with max. resolution 1920 x 1200 @ 60 Hz
> - Supports RGB with max. resolution 1920 x 1200 @ 60 Hz
>
> I'm even wondering electrically how a HDMI->dual-link DVI adapter works.

The current assumption is that in the working case, they are really
operated in single-link, with a frequency beyond the single-link DVI
cable spec.

BR,
Jani.



>
> Dave.

-- 
Jani Nikula, Intel Open Source Technology Center
