Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3APJTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:19:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:25317 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab3APJTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:19:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,478,1355126400"; 
   d="scan'208";a="244531643"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: daniel.vetter@ffwll.ch, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: -next: no resume from suspend
In-Reply-To: <50F3FFE6.4090108@suse.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <50F3D9E8.6040802@suse.cz> <16191961.j5ydKsJ3d3@vostro.rjw.lan> <50F3FFE6.4090108@suse.cz>
User-Agent: Notmuch/0.14+267~g79b3518 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 16 Jan 2013 11:20:43 +0200
Message-ID: <87fw21wkk4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Jiri Slaby <jslaby@suse.cz> wrote:
> On 01/14/2013 01:56 PM, Rafael J. Wysocki wrote:
>> On Monday, January 14, 2013 11:11:52 AM Jiri Slaby wrote:
>>> Hi,
>>>
>>> since friday's -next (the last known to be working is the last monday's)
>>> I cannot resume from suspend. The last thing I see with
>>> no_console_suspend is:
>>> i915: No ACPI video bus found
>>>
>>> But I used to see the message always, so this is no difference. Any idea
>>> before I start bisecting?
>> 
>> Well, what's the next message you normally see with no_console_suspend?
>
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>
> Adding DRM and intel guys.

Hi Jiri, the dmesgs for both cases with drm.debug=0xe module param might
give us some clues.

Does it work without no_console_suspend?


BR,
Jani.
