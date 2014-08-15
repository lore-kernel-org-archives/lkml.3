Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaHOFWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaHOFWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:22:02 -0400
Date: Fri, 15 Aug 2014 02:21:37 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
        rientjes@google.com, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrey Ryabinin <a.ryabinin@samsung.com>, lwoodman@redhat.com,
        Rik van Riel <riel@redhat.com>, jweiner@redhat.com
Subject: Re: mm: compaction: buffer overflow in isolate_migratepages_range
Message-ID: <20140815052136.GC26367@optiplex.redhat.com>
References: <CAPAsAGwk7kF6XtJNz6Y41zn0SHHzEt1Nwi_wC0gWgt0fpdp-ZQ@mail.gmail.com>
 <26c3333933769e4f9d1ed6226962a2f80719146b.1408050002.git.aquini@redhat.com>
 <20140814220704.GB26367@optiplex.redhat.com>
 <CALYGNiPbtav_ChUFW_kkh+HOHVmKeupTRsnKsaShK=p8ZKguBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiPbtav_ChUFW_kkh+HOHVmKeupTRsnKsaShK=p8ZKguBg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 07:36:16AM +0400, Konstantin Khlebnikov wrote:
> Don't hurry. The code in this state for years.
> I'm working on patches for this, if everything goes well I'll show it today.
> As usual I couldn't stop myself from cleaning the mess, so it will be
> bigger than yours.
>
Sorry,

I didn't see this reply of yours before sending out an adjusted-and-tested 
version of that patch, and asked Sasha to check it against his test-case.

Please, do not hesitate in providing your change ideas, though. I'd really
appreciate your assessment feedback on that code. 

Cheers,
-- Rafael
