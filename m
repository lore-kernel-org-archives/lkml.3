Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3DUO3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 10:29:02 -0400
Received: from one.firstfloor.org ([193.170.194.197]:49874 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3DUO3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 10:29:01 -0400
Date: Sun, 21 Apr 2013 16:29:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check
Message-ID: <20130421142900.GV16732@two.firstfloor.org>
References: <1366515340-17853-1-git-send-email-andi@firstfloor.org>
 <20130421095843.GB10683@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421095843.GB10683@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would be useful to read in the changelog about how you found the bug:
> 
>  - saw miscalculated values and figured out the reason
>  - saw a new warning in GCC
>  - saw it during review
> 
> ?

Saw it during code review when I was fixing the code for LTO.
I don't have a K6 anymore, but I still have fond memories of my K6
system.

-Andi

