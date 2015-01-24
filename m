Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbbAXAuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:50:16 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:42503 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAXAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:50:11 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "Vick\, Matthew" <matthew.vick@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>,
        "Kirsher\, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "e1000-devel\@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ethernet: fm10k: Actually drop 4 bits
Organization: D03
References: <1421967198-16667-1-git-send-email-linux@rasmusvillemoes.dk>
	<D0E81E0C.682EB%matthew.vick@intel.com>
X-Hashcash: 1:20:150124:jeffrey.t.kirsher@intel.com::sZSZ5nRtiQm0T8y2:00000000000000000000000000000000000K4c
X-Hashcash: 1:20:150124:matthew.vick@intel.com::FetJ4BG3H65+ru7n:00000000000000000000000000000000000000022YB
X-Hashcash: 1:20:150124:linux-kernel@vger.kernel.org::SfD9rgj2eZCyFctP:0000000000000000000000000000000002HBx
X-Hashcash: 1:20:150124:alexander.h.duyck@intel.com::RpoKr9lcA69kOO5W:00000000000000000000000000000000002Bh9
X-Hashcash: 1:20:150124:netdev@vger.kernel.org::JTbk9lkKQekBMsbO:0000000000000000000000000000000000000003dA5
X-Hashcash: 1:20:150124:e1000-devel@lists.sourceforge.net::k+3ZbfbAcGU88nyr:0000000000000000000000000000ACr8
Date: Sat, 24 Jan 2015 01:50:06 +0100
In-Reply-To: <D0E81E0C.682EB%matthew.vick@intel.com> (Matthew Vick's message
	of "Sat, 24 Jan 2015 00:18:59 +0000")
Message-ID: <87twzhknnl.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24 2015, "Vick, Matthew" <matthew.vick@intel.com> wrote:

> Good catch! I noticed this too and was getting a patch together to address
> this.
>
> The difference is that I was planning on not silently accepting an invalid
> VLAN ID to begin with and returning FM10K_ERR_PARAM if the VLAN was
> invalid, which I think is a better approach for this situation. If it's
> alright with you, I'll generate the patch shortly and credit you via your
> Reported-by.

Sure, do what you think is best.

Rasmus
