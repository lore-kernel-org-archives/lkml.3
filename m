Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3AUNzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:55:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:24596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab3AUNzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:55:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,506,1355126400"; 
   d="scan'208";a="193416467"
Message-ID: <50FD48B6.9010202@intel.com>
Date: Mon, 21 Jan 2013 14:55:02 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2013 7:38 AM, Feng Tang wrote:
> Hi All,
>
> On some new Intel Atom processors (Penwell and Cloverview), there is
> a feature that the TSC won't stop S3, say the TSC value won't be
> reset to 0 after resume. This feature makes TSC a more reliable
> clocksource and could benefit the timekeeping code during system
> suspend/resume cycles.
>
> The enabling efforts include adding new flags for this feature,
> modifying clocksource.c and timekeeping.c to support and utilizing
> it.
>
> One remaining question is inside the timekeeping_resume(), we don't
> know if it is called by resuming from suspend(s2ram) or from
> hibernate(s2disk), as there is no easy way to check it currently.
> But it doesn't hurt as these Penwell/Cloverview platforms only have
> S3 state, and no S4.
>
> Please help to review them, thanks!

The patches look reasonable to me.

Thanks,
Rafael

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

