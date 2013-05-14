Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3ENAk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:40:28 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60687 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3ENAk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:40:27 -0400
X-AuditID: 9c930197-b7b76ae000003523-6c-519187f9dcd2
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] perf report: Add --percent-limit option
References: <1368434503-29373-1-git-send-email-namhyung@kernel.org>
	<CAOJsxLGNBJBrB-zL5CJwVStFT=s0L919yjvSFga7j_NakLHLeA@mail.gmail.com>
Date: Tue, 14 May 2013 09:40:24 +0900
In-Reply-To: <CAOJsxLGNBJBrB-zL5CJwVStFT=s0L919yjvSFga7j_NakLHLeA@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 13 May 2013 11:58:22 +0300")
Message-ID: <87ppwu5r7r.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Mon, 13 May 2013 11:58:22 +0300, Pekka Enberg wrote:
> On Mon, May 13, 2013 at 11:41 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> The --percent-limit option is for not showing small overheaded entries
>> in the output.  Maybe we want to set a certain default value like 0.1.
>>
>> Cc: Andi Kleen <andi@firstfloor.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Thanks and sorry for missing you on CC list.
Namhyung
