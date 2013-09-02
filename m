Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3IBJXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:23:19 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41962 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3IBJXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:23:17 -0400
Date: Mon, 2 Sep 2013 11:23:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf_event: rdpmc self-monitoring overhead issue
Message-ID: <20130902092315.GI19750@two.firstfloor.org>
References: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
 <CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
 <87ob8cdji8.fsf@tassilo.jf.intel.com>
 <CAMsRxfLf4mSVEMnDr1AqD-=qrhBoeVWK6H0Jhb5kcHK7=OajmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfLf4mSVEMnDr1AqD-=qrhBoeVWK6H0Jhb5kcHK7=OajmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 10:24:13AM +0200, Stephane Eranian wrote:
> On Mon, Sep 2, 2013 at 4:50 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > Stephane Eranian <eranian@googlemail.com> writes:
> >
> >> I don't see a flag in mmap() to fault it in immediately.
> >
> > MAP_PRESENT
> >
> I could not find this constant defined anywhere in the kernel source tree
> nor in /usr/include. Are you sure of the name?

MAP_POPULATE sorry

-Andi

