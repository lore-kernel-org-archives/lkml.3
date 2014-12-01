Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaLAMQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:16:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:61618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaLAMQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:16:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="423524638"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Jay Aurabind <mail@aurabindo.in>, Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915 Trouble with minimum brightness
In-Reply-To: <547C5890.2020306@aurabindo.in>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <5478C9AA.2010600@aurabindo.in> <87k32bbtmo.fsf@intel.com> <547C5890.2020306@aurabindo.in>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Dec 2014 14:16:38 +0200
Message-ID: <87bnnnbm55.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2014, Jay Aurabind <mail@aurabindo.in> wrote:
>> Please file a new bug at [1], reference this mail, and attach
>> /sys/kernel/debug/dri/0/i915_opregion.
>
> Thank you for the response. But the file you mentioned to attach seems to be
> a binary file, because I'm getting lot of junk characters. Is this normal ?

Yes, it's binary.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
