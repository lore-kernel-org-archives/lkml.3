Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763050Ab3DDA4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:56:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50617 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761650Ab3DDA4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:56:38 -0400
X-AuditID: 9c930179-b7b2aae000000518-5b-515ccfc4381a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 10/10] perf sort: Consolidate sort_entry__setup_elide()
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
	<1364991979-3008-11-git-send-email-namhyung@kernel.org>
	<20130403170944.GB7238@ghostprotocols.net>
Date: Thu, 04 Apr 2013 09:56:36 +0900
In-Reply-To: <20130403170944.GB7238@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 3 Apr 2013 14:09:44 -0300")
Message-ID: <87hajndsfv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013 14:09:44 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Apr 03, 2013 at 09:26:19PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The same code was duplicate to places, factor them out to common
>> sort__setup_elide().
>
> Looks ok, applying after fixing up fuzzes due to this being at the end
> of the patchseries. Things like this that are clear cleanups are best
> positioned in the start of the patch series.

Will do that next time!

Thanks,
Namhyung
