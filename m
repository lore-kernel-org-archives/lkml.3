Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967247Ab3HIKtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:49:40 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:59311 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965852Ab3HIKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:49:38 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2013 06:49:38 EDT
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <5204C715.70501@vodafone.de>
Date: Fri, 09 Aug 2013 12:40:21 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Menzel <paulepanter@users.sourceforge.net>
CC: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: drm fixes for 3.11: Tag more patches for stable?
References: <alpine.DEB.2.00.1308090550580.3322@skynet.skynet.ie> <1376040290.5808.3.camel@mattotaupa>
In-Reply-To: <1376040290.5808.3.camel@mattotaupa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.08.2013 11:25, schrieb Paul Menzel:
> Dear Dave,
>
>
> Am Freitag, den 09.08.2013, 05:53 +0100 schrieb Dave Airlie:
>
> […]
>
>> The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:
>>
>>    Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)
>>
>> are available in the git repository at:
>>
>>    git://people.freedesktop.org/~airlied/linux drm-fixes
>>
>> for you to fetch changes up to e42f5814212079aecd5826dba10588a896ac0862:
>>
>>    Merge tag 'drm-intel-fixes-2013-08-08' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-08-09 09:09:37 +1000)
>>
>> ----------------------------------------------------------------
>>
>> Aaron Lu (1):
>>        drm/i915: avoid brightness overflow when doing scale
>>
>> Alex Deucher (11):
>>        drm/radeon: properly handle pm on gpu reset
>>        drm/radeon: select audio dto based on encoder id for DCE3
>>        drm/radeon/dpm: adjust thermal protection requirements
>>        drm/radeon/dpm: fix spread spectrum setup (v2)
>>        drm/radeon/dpm: adjust power state properly for UVD on SI
>>        drm/radeon/dpm: disable sclk ss on rv6xx
>>        drm/radeon: fix audio dto calculation on DCE3+ (v3)
>>        drm/radeon: always program the MC on startup
>>        drm/radeon/cik: use a mutex to properly lock srbm instanced registers
>>        drm/radeon/dpm: require rlc for dpm
>>        drm/radeon: make missing smc ucode non-fatal
>>
>> Christian König (5):
>>        drm/radeon: fix halting UVD
>>        drm/radeon: only save UVD bo when we have open handles
>>        drm/radeon: stop sending invalid UVD destroy msg
>>        drm/radeon: add more UVD CS checking
>>        drm/radeon: remove unnecessary unpin
> as UVD is also in 3.10 should more of these be tagged
> `stable@vger.kernel.org` too? I only checked
>
>          drm/radeon: add more UVD CS checking
>
> and it did not have that tag.

That patch doesn't have the tag because it is a (minor) new feature to 
check the incoming parameters for incorrect values and not a bugfix.

The other three UVD patches are bugfixes and indeed does have the 
necessary tag.

Regards,
Christian.

>
> […]
>
>
> Thanks,
>
> Paul

