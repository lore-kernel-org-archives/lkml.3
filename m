Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568Ab3LIVRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:17:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3LIVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:17:04 -0500
Date: Mon, 9 Dec 2013 22:16:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, joern@logfs.org,
        mgorman@suse.de, Michel Lespinasse <walken@google.com>,
        riel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kernel BUG in munlock_vma_pages_range
In-Reply-To: <52A5F83F.4000207@oracle.com>
Message-ID: <alpine.LRH.2.00.1312092215340.1515@twin.jikos.cz>
References: <52A3D0C3.1080504@oracle.com> <52A58E8A.3050401@suse.cz> <52A5F83F.4000207@oracle.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Sasha Levin wrote:

> Not really, the fuzzer hit it once and I've been unable to trigger it 
> again. 

If you are ever able to trigger it again, I think having crashdump 
available would be very helpful here, to see how exactly does the VMA/THP 
layout look like at the time of crash.

Any chance you run your fuzzing with crashkernel configured for a while?

-- 
Jiri Kosina
SUSE Labs

