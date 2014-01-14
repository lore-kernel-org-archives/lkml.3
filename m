Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaANMtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:49:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:40257 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbaANMtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:49:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="scan'208";a="438596476"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
In-Reply-To: <Pine.LNX.4.44L0.1401131512380.2032-100000@iolanthe.rowland.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <Pine.LNX.4.44L0.1401131512380.2032-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.17+27~gabca3dcf08ba (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Jan 2014 14:52:17 +0200
Message-ID: <8738kqafpa.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 8 Jan 2014, Daniel Vetter wrote:
>
>> On Wed, Jan 08, 2014 at 01:34:02PM -0500, Alan Stern wrote:
>> > On Wed, 8 Jan 2014, Daniel Vetter wrote:
>> > 
>> > > On Wed, Jan 08, 2014 at 11:08:08AM -0500, Alan Stern wrote:
>> > > > On Tue, 7 Jan 2014, Daniel Vetter wrote:
>> > > > 
>> > > > > I really want users to report these issues, and excessive WARNs seems
>> > > > > to be the only way to get those reports. Please boot with
>> > > > > drm.debug=0xe added to your kernel cmdline and reproduce this issues.
>> > > > > Also, which precise kernel are you running? Testing latest -rc is
>> > > > > always recommended, this state checker code is fairly new and gets
>> > > > > constantly extended and bugs fixed ...
>> > > > 
>> > > > Here you go.  This is the dmesg output after booting with
>> > > > drm.debug=0xe.  Pay no attention to the "AS" suffix in the version
>> > > > string; this is pristine 3.13-rc7.
>> > > 
>> > > That's strange, I've thought we've fixed the last struggling mismatch in
>> > > the lvds borber bits stuff. Can you please try latest drm-intel-nightly
>> > > from
>> > > 
>> > > http://cgit.freedesktop.org/~danvet/drm-intel/
>
> I posted the output from the default branch in that repository last
> week:
>
> 	http://marc.info/?l=linux-kernel&m=138922294308576&w=2
>
> Have you had time to look at the results yet?

I think it might be the time to file this as a new bug on DRM/Intel at
https://bugs.freedesktop.org/enter_bug.cgi?product=DRI

BR,
Jani.


>
> Alan Stern
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Jani Nikula, Intel Open Source Technology Center
