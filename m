Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaLHLE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:04:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:35258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbaLHLEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:04:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,537,1413270000"; 
   d="scan'208";a="620341161"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>, Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        jaime.91@hotmail.es, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/opregion: work around buggy	firmware that provides 8+ output devices
In-Reply-To: <8761dmo17c.fsf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <52FAE504.8020001@intel.com> <20140212103156.GC5298@nuc-i3427.alporthouse.com> <52FC8C01.1040002@intel.com> <20140213100814.GM14909@nuc-i3427.alporthouse.com> <CAKMK7uGN3Of2VU6_LsSLh041kkx4TrhyH0H8zvE-PRvOtzJgfg@mail.gmail.com> <53045DD1.5010406@intel.com> <20140219073339.GA30685@srcf.ucam.org> <5304725A.3020909@intel.com> <20140304144504.GE17001@phenom.ffwll.local> <548505D2.8030904@intel.com> <8761dmo17c.fsf@intel.com>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 08 Dec 2014 13:04:34 +0200
Message-ID: <87388qo119.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2014, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> On Mon, 08 Dec 2014, Aaron Lu <aaron.lu@intel.com> wrote:
>> We have a new bug report that has the same problem:
>> https://bugzilla.kernel.org/show_bug.cgi?id=88941
>>
>> The posted patch solves the problem. I know it's not perfect, but it
>> doesn't seem it would do any harm to existing systems so should be safe.
>>
>> Better, if someone can shed some light on how this should be properly
>> handled, that would be great.
>
> There was a bug report that I can't find right now that had a similar
> problem. I wrote a few patches, even somewhat polished ones (that I now
> pushed to [1] for reference) to handle extended DIDL. Unfortunately this
> didn't help the bug reporter because the right one was beyond the
> extended DIDL too, so I don't think I even sent these to the list.
>
> Anyway, just one more data point. This might help your reporter, so
> worth a try. But it doesn't solve everything.

[1] http://cgit.freedesktop.org/~jani/drm/log/?h=didl


-- 
Jani Nikula, Intel Open Source Technology Center
