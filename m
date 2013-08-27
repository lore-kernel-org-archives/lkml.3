Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3H0Stv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:49:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41957 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3H0Stu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:49:50 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130827093454.GJ26909@phenom.ffwll.local>
References: <1374870772-4592-1-git-send-email-jbarnes@virtuousgeek.org> <20130827093454.GJ26909@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Intel-gfx] Updated stolen mem patches
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 27 Aug 2013 13:49:08 -0500
To: Daniel Vetter <daniel@ffwll.ch>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, torvalds@linux-foundation.org, tglx@linutronix.de
Message-ID: <52896c00-6711-4558-9754-e1bba1f81078@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If noone hers to them first poke me tomorrow. On an aircraft right now.

Daniel Vetter <daniel@ffwll.ch> wrote:
>On Fri, Jul 26, 2013 at 01:32:50PM -0700, Jesse Barnes wrote:
>> These address the comments I've received so far, but omit the new
>E820
>> type for this mem.
>> 
>> Chris's patches could go on top if desired; they add a new type and
>> resource reservation function for looking up regions by name.  That
>> allows us to remove some duplicate code in the driver for finding
>stolen
>> space.
>> 
>> But I think these two are ready as-is.  How should we merge them? 
>Just
>> through the i915 tree since the first one touches our headers?  that
>and
>> there probably won't be conflicts on the early-quirks file; that's
>not
>> touch too often...
>
>Just noticed that these patches aren't in -next yet - somehow I've
>thought
>they'd go in in through the x86 tree.
>
>Ingo et al: Should I merge these through drm-intel-next or will you
>pick
>them up?
>
>Thanks, Daniel

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
