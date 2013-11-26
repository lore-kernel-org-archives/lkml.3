Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3KZTLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:11:23 -0500
Received: from one.firstfloor.org ([193.170.194.197]:52140 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3KZTLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:11:22 -0500
Date: Tue, 26 Nov 2013 20:11:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131126191119.GL29695@two.firstfloor.org>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
 <5294F10C.8060901@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5294F10C.8060901@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IIRC someone proposed that, rather than specifying a "handler", that any
> user thread that traps just wait until the poke completes.  This would
> complicate the kernel implementation a bit, but it would make the user
> code a good deal simpler.  Is there any reason that this is a bad idea?

Should be doable yes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
