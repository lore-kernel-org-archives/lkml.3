Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaDIA6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:58:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:32970 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaDIA6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:58:09 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 03/15 V3] perf c2c: Shared data analyser
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-4-git-send-email-dzickus@redhat.com>
	<87a9bwxq64.fsf@sejong.aot.lge.com> <20140408142226.GV8488@redhat.com>
Date: Wed, 09 Apr 2014 09:58:04 +0900
In-Reply-To: <20140408142226.GV8488@redhat.com> (Don Zickus's message of "Tue,
	8 Apr 2014 10:22:26 -0400")
Message-ID: <87ioqjuxnn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 10:22:26 -0400, Don Zickus wrote:
> On Tue, Apr 08, 2014 at 03:59:15PM +0900, Namhyung Kim wrote:
>> Hi Don,
>> 
>> On Mon, 24 Mar 2014 15:36:54 -0400, Don Zickus wrote:
>> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
>> >
>> > This is the start of a new perf tool that will collect information about
>> > memory accesses and analyse it to find things like hot cachelines, etc.
>> 
>> So why not integrating this into existing 'perf mem' command if it's all
>> about analyzing memory accesses?
>
> Our expectations were different.  We expeted to do system-wide analysis
> with loads and stores.  With 'perf mem' you didn't have the ability to
> anlayze both load and stores at the same time.

But it's very simple to change perf mem to work with the both IMHO.

>
> In all my private conversations with Stephane, Arnalado and Jiri, it was
> never brought up.  We had just assumed that is made more sense to keep it
> separate.

Well, I'm not sure ;-)  Yes, the c2c is a complex tool which might
deserve an own command, but the functionality is very similar and I
guess there's something to share between them.

Thanks,
Namhyung
