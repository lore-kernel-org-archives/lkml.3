Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3KTUzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:55:09 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:34065 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3KTUy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:54:56 -0500
Date: Wed, 20 Nov 2013 21:54:53 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: sclark46@earthlink.net
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] i915 driver gpu hung kernel 3.11
Message-ID: <20131120215453.03109171@neptune.home>
In-Reply-To: <528D0E97.9020700@earthlink.net>
References: <52896862.5000300@earthlink.net>
	<20131118184107.67d6c875@neptune.home>
	<528B5581.8040006@earthlink.net>
	<20131120182649.1f2bd411@neptune.home>
	<528D0E97.9020700@earthlink.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 20 November 2013 Stephen Clark <sclark46@earthlink.net> wrote:
> Hi Bruno,
> 
> I have tested the latest kernel and X, mesa etc, but am still using
> wine-1.3.24.
> I am working on upgrading that. If I still have the error I will file
> a bug report at bugs.freedesktop.org. I already have a login because
> of the same problem happening with Myst 5, but it was never resolved.

If you add an error_state file to the bug you should have rather good
chance to get it solved (of course mentioning the various software
versions in use - mesa, libdrm, xf86-video-intel, wine, kernel).

> Do you know if there is a comprehensive set of test I can run to make
> sure my hardware is OK. When I run dxdiag under wine it passes all
> tests, but then when trying to play Myst online or Myst 5
> I get the gpu hung situation.

I've not heard of a comprehensive test suite though.
It probably is a bug in the driver (libdrm, mesa or xf86-video-intel).

I think I've identified your bug as #32582 for the Myth 5 hang.
As Chris Wilson has already replied to it, it's maybe just a matter of
re-testing with current software, mentioning those versions (and
including error_state).
If you get no feedback you usually have a good chance attracting attention
to the bug(s) by showing up on #intel-gfx IRC channel on freenode and
referring to the bug (and stay around long enough to catch possible
replies - an be prepared to apply patches and recompile/test to verify
if a proposed fix helps).
If there are multiple games hanging the GPU (via Wine) they might even
all trigger the same issue, thus having error_state for both will be
an advantage.

Bruno

> Anyway thanks for taking the time to respond.
> 
> Regards,
> Steve
