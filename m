Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbaDICsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:48:37 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43916 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbaDICsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:48:35 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
In-Reply-To: <CAKMK7uE=F_T9M6L7U7t7xeJLdJXbhYF+MbvrsAeYeSqCC=hKKA@mail.gmail.com>
References: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
	<878urg9ttv.fsf@intel.com>
	<CAMVG2suG7ysnci25Cy_+fzvQ8r_R9O2nCuVZf=Zw9t5ZvEOSLQ@mail.gmail.com>
	<CAKMK7uE=F_T9M6L7U7t7xeJLdJXbhYF+MbvrsAeYeSqCC=hKKA@mail.gmail.com>
Date: Wed, 9 Apr 2014 10:48:34 +0800
Message-ID: <CAMVG2ssELOqn8BHVwUMu1+X9LKNWQEA2Bpk+n+bVOvxOFGHktg@mail.gmail.com>
Subject: Re: [Intel-gfx] i915 DVI resolution regression (3.13.7+)
From: Daniel J Blueman <daniel@quora.org>
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville et al,

On 8 April 2014 16:02, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Tue, Apr 8, 2014 at 9:32 AM, Daniel J Blueman <daniel@quora.org> wrote:
>> I am using a dual-link DVI-D to DVI-D cable to this monitor, since I
>> previously couldn't get 2560x1440 via HDMI.
>>
>> If it isn't this commit, then it may be another commit in 3.13.7,
>> albeit it feels less likely.
>
> Before we go on a wild goose chase, can you please confirm your
> suspicion with a revert?

I built stock 3.13.7 to reproduce the issue (Ubuntu mainline config);
I reverted e3ea8fa6beaf55fee64bf816f3b8a80ad733b2c2 and rebuilt, and
don't see the issue. It's probably an idea if you have a panel that
requires dual-link DVI on the automated test matrix if not already.

Anyway, glad to have helped.

Thanks,
  Daniel
-- 
Daniel J Blueman
