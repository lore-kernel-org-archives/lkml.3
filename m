Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaGJLvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:51:03 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:34754 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbaGJLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:50:59 -0400
Message-ID: <53BE7E10.5000805@tu-dresden.de>
Date: Thu, 10 Jul 2014 13:50:40 +0200
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]  perf script: Add callchain to generic and tracepoint
 events
References: <87wqd5f7j5.fsf@sejong.aot.lge.com> <538F0BF2.1010806@tu-dresden.de> <20140707171706.GA20752@krava.redhat.com> <53BCF1F2.70100@tu-dresden.de> <20140709112721.GC1814@krava.redhat.com> <53BD2AD6.6020309@tu-dresden.de> <20140709114903.GA5767@krava.redhat.com> <53BD4EC1.1060907@tu-dresden.de> <20140709190921.GD5721@kernel.org> <20140709191223.GE5721@kernel.org> <20140709192926.GF5721@kernel.org>
In-Reply-To: <20140709192926.GF5721@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On 09.07.2014 21:29, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 09, 2014 at 04:12:23PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Wed, Jul 09, 2014 at 04:09:21PM -0300, Arnaldo Carvalho de Melo escreveu:
>
>> It is full of:
>  
>>                 self.cpu =3D common_cpu
> 
> Ok, I applied the first patch on this series, please see my perf/core
> branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
> 
> You can have it with:
> 
>   git remote add acme git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>   git checkout -b perf/core acme/perf/core
> 
> Then please create the patches and follow the instructions about
> Thunderbird at:
> 
> https://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html
> 
> So that it doesn't mangles the patch and resend, ok?

Thanks for figuring out what the problem was, the patches looked fine when I checked them in my outbox. I had Thunderbird set up according to the documentation you mentioned. However, after some testing I found out what went wrong on my side: we have the policy at work to sign all of our emails using s/mime so I have TB set up to do this by default. This seems to mangle the emails and there is no way to notice that in Thunderbird because it automatically removes the mangling when displaying signed mails. Lesson learned, again sorry for all the trouble! I will resend the patches based on the current perf/core and be more careful next time. 

Thanks
Joseph

> 
> - Arnaldo
> 
