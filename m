Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311AbaFSV7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:59:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55074 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966278AbaFSV7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140619160946.GX5821@phenom.ffwll.local>
References: <nsxppi6tcsg.fsf@closure.thunk.org>
	<20140619160946.GX5821@phenom.ffwll.local>
Date: Fri, 20 Jun 2014 07:59:04 +1000
Message-ID: <CAPM=9tyarFzh4YdXz07rzhiSSNK149ov5LpZwehtC=UismKNBg@mail.gmail.com>
Subject: Re: [Intel-gfx] Display glitching (and possibly related lockup) in 3.16-rc1?
From: Dave Airlie <airlied@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2014 02:09, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Jun 18, 2014 at 12:14:55PM -0400, Theodore Ts'o wrote:
>> Is this a known problem?
>>
>> On my T540p, occasionally the display will go black and then be
>> completely locked.  One time when this happened, the display started
>> glitching and tearing (like what you might see if an analog display had
>> a loose connector and it was being wiggled) when the system locked up,
>> but the at least 75% of the time when the bug manifests, the screen goes
>> black instead.
>>
>> This appears to only happen when the system is running on battery --- it
>> doesn't seem to manifest if I'm plugged into the AC mains.  And I've
>> been typing an e-mail message when the system locks up, so I don't think
>> it's related to DPMS or the screen saver kicking in.
>>
>> I can try to bisect this regression (3.15 didn't have this problem), but
>> I thought I would ask first if this was a known problem.   I don't know
>> for certain that it's an i915 bug, but the symptoms do somewhat point in
>> that direction, especially the display glitches.
>
> Doesn't ring a bell, but can you please boot with drm.debug=0xe and attach
> dmesg here so we know what kind of hardware you have? Also any dying
> breadths over netconsole or similar? Can't hurt to check that before doing
> the bisect.
>

t540p are haswell.

Dave.
