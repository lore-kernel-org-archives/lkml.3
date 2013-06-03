Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab3FCS1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:27:33 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:48133 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3FCS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:27:31 -0400
MIME-Version: 1.0
In-Reply-To: <51ACDFBF.3030909@gmail.com>
References: <20130603180646.GE8758@krava.brq.redhat.com>
	<51ACDFBF.3030909@gmail.com>
Date: Mon, 3 Jun 2013 20:27:31 +0200
Message-ID: <CABPqkBRNNecbL_o4TyGQR6KX83CbgyXqu_3QhQN0z4Z43ciwNQ@mail.gmail.com>
Subject: Re: [RFC] perf record: Remove -A option
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have never used this option nor do I know people who do.

On Mon, Jun 3, 2013 at 8:26 PM, David Ahern <dsahern@gmail.com> wrote:
> On 6/3/13 12:06 PM, Jiri Olsa wrote:
>>
>> hi,
>> the -A option (append data to the output file) for record
>> command is broken, probably for some time now.
>>
>> Anyone interested in this functionality? As we discussed
>> this with Arnaldo he and I would vote for removal.
>>
>> thoughts?
>
>
> Acked-by: David Ahern <dsahern@gmail.com>
>
> I ran a bisect on this problem a year ago:
> http://lkml.indiana.edu/hypermail/linux/kernel/1206.3/00990.html
>
> "Append has been broken for a long time (v2.6.36 last working version)."
>
> David
