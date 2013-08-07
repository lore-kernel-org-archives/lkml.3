Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630Ab3HGVdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:33:35 -0400
Received: from ozlabs.org ([203.10.76.45]:59479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933317Ab3HGVde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:33:34 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130807201624.GG2665@ghostprotocols.net>
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au> <20130806135937.GB1068@krava.brq.redhat.com> <20130807051957.GC19998@concordia> <20130807201624.GG2665@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] perf tools: Add support for pinned modifier
From: Michael Ellerman <michael@ellerman.id.au>
Date: Thu, 08 Aug 2013 07:33:28 +1000
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Message-ID: <33b4715b-dd44-4d4a-a45b-7c02de479be1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
>Em Wed, Aug 07, 2013 at 03:19:57PM +1000, Michael Ellerman escreveu:
>> On Tue, Aug 06, 2013 at 03:59:37PM +0200, Jiri Olsa wrote:
>> > On Tue, Aug 06, 2013 at 11:28:05PM +1000, Michael Ellerman wrote:
>> > > +		if (evsel->leader == evsel)
>> > > +			evsel->attr.pinned = mod.pinned;
>
>> > nitpick, we have perf_evsel__is_group_leader for this check
> 
>> Ah darn, missed it.
>
>> Should I do a respin?
>
>No need, I did it.

Thanks.

cheers

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
