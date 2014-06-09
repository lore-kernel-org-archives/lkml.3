Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaFIJZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:25:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36766 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaFIJZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:25:21 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140607231124.GA3611@amd.pavel.ucw.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
	<20140513163734.GA4602@amd.pavel.ucw.cz>
	<20140513214155.GA5087@amd.pavel.ucw.cz>
	<alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
	<20140514155759.GB9723@amd.pavel.ucw.cz>
	<20140514182046.GA13342@amd.pavel.ucw.cz>
	<alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
	<CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
	<20140607120614.GB5309@amd.pavel.ucw.cz>
	<20140607231124.GA3611@amd.pavel.ucw.cz>
Date: Mon, 9 Jun 2014 11:25:20 +0200
Message-ID: <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
Subject: Re: 3.15-rc: regression in suspend
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 1:11 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Strange. It seems 3.15 with the patch reverted only boots in 30% or so
> cases... And I've seen resume failure, too, so maybe I was just lucky
> that it worked for a while.

git bisect really likes 25f397a429dfa43f22c278d0119a60 - you're about
the 5th report or so that claims this is the culprit but it's
something else. The above code is definitely not used in i915 so bogus
bisect result.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
