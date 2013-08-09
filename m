Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967107Ab3HIKeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:34:04 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:60009 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966854Ab3HIKeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <1376040290.5808.3.camel@mattotaupa>
References: <alpine.DEB.2.00.1308090550580.3322@skynet.skynet.ie>
	<1376040290.5808.3.camel@mattotaupa>
Date: Fri, 9 Aug 2013 20:33:42 +1000
Message-ID: <CAPM=9tzTVnWKzDWwHmeB4o0jmo7+_is7C0CNqWgpMrWUU-wXng@mail.gmail.com>
Subject: Re: drm fixes for 3.11: Tag more patches for stable? (was: [git pull]
 drm fixes)
From: Dave Airlie <airlied@gmail.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 7:25 PM, Paul Menzel
<paulepanter@users.sourceforge.net> wrote:
> Dear Dave,
>
>
> Am Freitag, den 09.08.2013, 05:53 +0100 schrieb Dave Airlie:
>
> […]
>
>> The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:
>>
>>   Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)
>>
>> are available in the git repository at:
>>
>>   git://people.freedesktop.org/~airlied/linux drm-fixes
>>
>> for you to fetch changes up to e42f5814212079aecd5826dba10588a896ac0862:
>>
>>   Merge tag 'drm-intel-fixes-2013-08-08' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-08-09 09:09:37 +1000)
>>
>> ----------------------------------------------------------------
>>
>> Aaron Lu (1):
>>       drm/i915: avoid brightness overflow when doing scale
>>
>> Alex Deucher (11):
>>       drm/radeon: properly handle pm on gpu reset
>>       drm/radeon: select audio dto based on encoder id for DCE3
>>       drm/radeon/dpm: adjust thermal protection requirements
>>       drm/radeon/dpm: fix spread spectrum setup (v2)
>>       drm/radeon/dpm: adjust power state properly for UVD on SI
>>       drm/radeon/dpm: disable sclk ss on rv6xx
>>       drm/radeon: fix audio dto calculation on DCE3+ (v3)
>>       drm/radeon: always program the MC on startup
>>       drm/radeon/cik: use a mutex to properly lock srbm instanced registers
>>       drm/radeon/dpm: require rlc for dpm
>>       drm/radeon: make missing smc ucode non-fatal
>>
>> Christian König (5):
>>       drm/radeon: fix halting UVD
>>       drm/radeon: only save UVD bo when we have open handles
>>       drm/radeon: stop sending invalid UVD destroy msg
>>       drm/radeon: add more UVD CS checking
>>       drm/radeon: remove unnecessary unpin
>
> as UVD is also in 3.10 should more of these be tagged
> `stable@vger.kernel.org` too? I only checked
>
>         drm/radeon: add more UVD CS checking
>
> and it did not have that tag.

I think if they are required they might be best done via separate
backports, not sure how much the code has changed but dpm moved a lot
of stuff around.

Dave.
