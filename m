Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3CRNTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:19:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13505 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3CRNTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:19:30 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=l-zTcuvMFTkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=An5aTDfC5mAA:10 a=FJW4dWLIFbhahgIFMpgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363612769.25967.139.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 9/9] tracing: Update debugfs README file
From: Steven Rostedt <rostedt@goodmis.org>
To: Keun-O Park <kpark3469@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Date: Mon, 18 Mar 2013 09:19:29 -0400
In-Reply-To: <CA+KhAHadpCEFvLaZDU1ahwDc7zxDJu_rUtAz2a55T_K8EN+G5g@mail.gmail.com>
References: <20130316032412.416651612@goodmis.org>
	 <20130316033143.744766877@goodmis.org> <87hak9jewo.fsf@sejong.aot.lge.com>
	 <CA+KhAHadpCEFvLaZDU1ahwDc7zxDJu_rUtAz2a55T_K8EN+G5g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 18:03 +0900, Keun-O Park wrote:

> >> +#endif
> >> +#ifdef CONFIG_TRACER_SNAPSHOT
> >> +     "\n  snashot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
> >> +     "\t\t\t  Read the contents for more infromation\n"
> >> +#endif
> 
> There're two more typos.
> s/snashot/snapshot/
> s/infromation/information/
> 

spellcheck doesn't work well for patches. Thanks,

-- Steve


