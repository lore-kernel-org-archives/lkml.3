Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab3AOMUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:20:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51090 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab3AOMUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:20:00 -0500
Date: Tue, 15 Jan 2013 13:19:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130115121958.GC3728@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20130110093831.GA19503@liondog.tnic>
 <CADnq5_N9Dj5ZMoDaL9hp6R5wMkEf2yEL1C=66-PQ2+sLwwTm3g@mail.gmail.com>
 <20130110203248.GI23008@liondog.tnic>
 <CADnq5_MMk51H+Zy9GT9esfm_ndVqYzwU4t_6tYHu9zzSiqSr9g@mail.gmail.com>
 <20130111114336.GE6570@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130111114336.GE6570@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 12:43:36PM +0100, Borislav Petkov wrote:
> Ok, I'm running -rc3 with this and will watch it for any changes in
> behavior.

AFAICT, this fixes the CP stalls, for I haven't seen any of them in
dmesg for the last couple of days after applying your revert.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
