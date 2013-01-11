Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3AKThd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:37:33 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:47987 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3AKThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:37:32 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130111065738.GB27583@fancy-poultry.org>
References: <alpine.DEB.2.00.1301102155250.6541@skynet.skynet.ie>
	<20130111065738.GB27583@fancy-poultry.org>
Date: Fri, 11 Jan 2013 20:37:30 +0100
X-Google-Sender-Auth: Zydyp8NnGXRi72MkfQXB9PR6EJ8
Message-ID: <CAKMK7uGhVjyWYZVip6g5KO9F3OCKd-UMw0a0hxb5kzGyzfv7vg@mail.gmail.com>
Subject: Re: [git pull] drm intel fixes
From: Daniel Vetter <daniel@ffwll.ch>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 7:57 AM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> On 11.01.2013, Dave Airlie wrote:
>
>> Just intel fixes, including getting the Ironlake systems back to the state
>> they were in for 3.6.
>
>>       drm/i915: Revert shrinker changes from "Track unbound pages"
>
> I guess it's this one which fixes the ILK hang. Would it be enough for
> 3.7 to just appy this patch to get the problem fixed?

Both pieces of duct-tape are cc: stable, so should quickly pop up on
3.7. The other one is "drm: Only evict the blocks required to create
the requested hole", both should apply to 3.7 without fuzz.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
