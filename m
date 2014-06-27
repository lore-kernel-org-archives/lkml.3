Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaF0WsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:48:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:33793 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaF0WsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="450934371"
From: Andi Kleen <andi@firstfloor.org>
To: Nawn Given <wood.quinn.s@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Writing Device Drivers
References: <CAM83q7BgHSUs5RyWQat_z4O=1sGgecOUb11jAxkun4JSUOe-cg@mail.gmail.com>
Date: Fri, 27 Jun 2014 15:48:03 -0700
In-Reply-To: <CAM83q7BgHSUs5RyWQat_z4O=1sGgecOUb11jAxkun4JSUOe-cg@mail.gmail.com>
	(Nawn Given's message of "Fri, 27 Jun 2014 16:54:20 -0500")
Message-ID: <87y4wivujg.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nawn Given <wood.quinn.s@gmail.com> writes:

> I recently read some post-commentary on very old Linux mailing list
> messages (announcement to 0.96.)
>
> I'm interested in how someone writes a driver for their hardware. What
> is the process (or if it's become harder to explain since the early
> 90s, what was the process back then) for Linux?

1. Open editor
2. Type code
3. Test code
4. Repeat until code works.

No substantial change since 0.96 as far as I know.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
