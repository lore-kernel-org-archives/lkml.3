Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3APJWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:22:53 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58437 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab3APJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:22:51 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-f7-50f6716960f8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 06/13] perf ui/hist: Add support for event group view
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
	<1358235117-12803-7-git-send-email-namhyung@kernel.org>
	<20130115183110.GB5826@ghostprotocols.net>
Date: Wed, 16 Jan 2013 18:22:49 +0900
In-Reply-To: <20130115183110.GB5826@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 15 Jan 2013 15:31:10 -0300")
Message-ID: <87ip6xmqhi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:31:10 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 15, 2013 at 04:31:50PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Show group members' overhead also when showing the leader's if event
>> group is enabled.  Use macro for defining hpp functions which looks
>> almost identical.
>> 
>> Thanks to Arnaldo for suggesting a better way to print group members
>> without allocating temporary array.
>
> Thanks! Its a pity the patch ended up mixing up things, I'll have to
> apply it and look at the end result.

Do you mean I have to separate this into two - one for converting to
macro and another for event group view itself?

Thanks,
Namhyung
