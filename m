Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab3APJwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:52:07 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43021 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab3APJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:52:04 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-b3-50f67843748f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/13] perf hist browser: Add support for event group view
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
	<1358235117-12803-8-git-send-email-namhyung@kernel.org>
	<20130115183226.GC5826@ghostprotocols.net>
Date: Wed, 16 Jan 2013 18:52:03 +0900
In-Reply-To: <20130115183226.GC5826@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 15 Jan 2013 15:32:26 -0300")
Message-ID: <87ehhlmp4s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:32:26 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 15, 2013 at 04:31:51PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Show group members' overhead also when showing the leader's if event
>> group is enabled.  Use macro for defining hpp functions which looks
>> almost identical.
>> 
>> Also move coloring logic into the hpp function so that each value can
>> be colored independently.
>
> Just from reading the description: when we have this "Also do this extra
> thing" it smells like we need to break the patch in two... Can this be
> done?

Sure.  I'll break it.

Thanks,
Namhyung
