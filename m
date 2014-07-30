Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaG3JkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:40:12 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:61548 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaG3JkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:40:06 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53D8565E.3080707@intel.com>
References: <53d70753.0iBGqYd97TVbYboG%fengguang.wu@intel.com>
	<53D70A36.4030907@intel.com>
	<20140729101430.GT27580@intel.com>
	<CAKMK7uHDkeWyvG-xUEfhZXmo5a+RiBt+huT1My2zG6ibePNuFw@mail.gmail.com>
	<53D8565E.3080707@intel.com>
Date: Wed, 30 Jul 2014 11:40:05 +0200
Message-ID: <CAKMK7uHAH5is3+CGOxTimxjx2x1auYf4gXAzWjkuTdB2mRkk-Q@mail.gmail.com>
Subject: Re: [LKP] [drm/i915] WARNING: CPU: 3 PID: 248 at drivers/gpu/drm/i915/intel_pm.c:6427
 check_power_well_state+0x60/0x90 [i915]()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Aaron Lu <aaron.lu@intel.com>
Cc: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 4:20 AM, Aaron Lu <aaron.lu@intel.com> wrote:
> On 07/29/2014 07:10 PM, Daniel Vetter wrote:
>> On Tue, Jul 29, 2014 at 12:14 PM, Ville Syrjälä
>> <ville.syrjala@linux.intel.com> wrote:
>>> On Tue, Jul 29, 2014 at 10:43:02AM +0800, Aaron Lu wrote:
>>>> FYI, we noticed the below changes on
>>>>
>>>> git://people.freedesktop.org/~danvet/drm colder-fusion
>>>
>>> Does it happen on -nightly too?
>>
>> git://anongit.freedesktop.org/drm-intel
>
> With this git tree, do we still need to watch the old one? Or they serve
> different purpose?

The old one is just my private repo, never contained official
branches. The one I've given is the official drm-intel git for
upstream.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
