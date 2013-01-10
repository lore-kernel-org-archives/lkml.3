Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3AJUcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:32:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59544 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab3AJUcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:32:51 -0500
Date: Thu, 10 Jan 2013 21:32:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130110203248.GI23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20130110093831.GA19503@liondog.tnic>
 <CADnq5_N9Dj5ZMoDaL9hp6R5wMkEf2yEL1C=66-PQ2+sLwwTm3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADnq5_N9Dj5ZMoDaL9hp6R5wMkEf2yEL1C=66-PQ2+sLwwTm3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:21:21AM -0500, Alex Deucher wrote:
> I'm assuming you didn't also update your userspace gfx stack?

By that you mean x.org etc, right? Or GPU microcode too? In any case, I
haven't touched any of those deliberately, AFAICR at least.

> Does disabling the new DMA ring for ttm bo moves avoid the issue?

How do I do that?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
