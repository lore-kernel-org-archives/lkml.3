Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3I0Jgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:36:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:59607 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab3I0Jga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,991,1371106800"; 
   d="scan'208";a="300064377"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Vincent =?utf-8?Q?Ste?= =?utf-8?Q?hl=C3=A9?= 
	<vincent.stehle@laposte.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] gma500: define do_gma_backlight_set only when used
In-Reply-To: <CAMeQTsZoPoDBeBrnM9zRLo8qKjm0+ZtZ15NeUqt_imJUNg-M2Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1380232016-25368-1-git-send-email-vincent.stehle@laposte.net> <CAMeQTsZoPoDBeBrnM9zRLo8qKjm0+ZtZ15NeUqt_imJUNg-M2Q@mail.gmail.com>
User-Agent: Notmuch/0.16+82~gc83e2d2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 27 Sep 2013 12:38:54 +0300
Message-ID: <87ppru4n9t.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
>> +#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE

Hi, while at it, you should probably let backlight be built as module:

#if IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)


Cheers,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
