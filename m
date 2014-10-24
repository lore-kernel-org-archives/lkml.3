Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaJXM1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:27:46 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:36244 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbaJXM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <544A2E5F.80508@intel.com>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-6-git-send-email-adrian.hunter@intel.com>
 <87lho6c8ec.fsf@sejong.aot.lge.com> <544A099C.50104@intel.com> <544A2E5F.80508@intel.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 24 Oct 2014 21:26:55 +0900
X-Google-Sender-Auth: zPbvZxq7AJtmHSwdm-1Z1vPViXs
Message-ID: <CAM9d7ci6bv_JnK8DkqqTEttPkEp1mtMPN07XjqX=K4ADOUC6SA@mail.gmail.com>
Subject: Re: [PATCH 05/16] perf tools: Add facility to export data in
 database-friendly way
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Fri, Oct 24, 2014 at 7:47 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 24/10/14 11:11, Adrian Hunter wrote:
>> On 24/10/14 09:02, Namhyung Kim wrote:
>>> Can we do it somewhere in a script not in the core code?  I don't feel
>>> comfortable to add those bits into the core code.  What if we export
>>
>> Please explain what you mean by "comfortable".
>
> Or rather: What about it is wrong for core code?

Well, there's nothing "wrong" about it. :)

But I think if some code is used only by a specific bits, it'd be
better hiding it from the rest as much as possible.

Thanks,
Namhyung
