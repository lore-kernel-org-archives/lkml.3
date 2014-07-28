Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaG1BU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 21:20:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:8521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaG1BU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 21:20:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,745,1400050800"; 
   d="scan'208";a="568099240"
From: Andi Kleen <andi@firstfloor.org>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org, khalid.aziz@oracle.com
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
Date: Sun, 27 Jul 2014 18:19:56 -0700
In-Reply-To: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	(Sergey Oboguev's message of "Fri, 25 Jul 2014 12:45:21 -0700")
Message-ID: <8738dm9t4z.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Oboguev <oboguev.public@gmail.com> writes:

> [This is a repost of the message from few day ago, with patch file
> inline instead of being pointed by the URL.]

Have you checked out the preemption control that was posted some time
ago? It did essentially the same thing, but somewhat simpler than your 
patch.

http://lkml.iu.edu/hypermail/linux/kernel/1403.0/00780.html

Yes I agree with you that lock preemption is a serious issue that needs solving.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
