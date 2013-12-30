Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3L3C6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:58:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:14408 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab3L3C6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:58:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,571,1384272000"; 
   d="scan'208";a="9348353"
Message-ID: <52C1969A.30903@cn.fujitsu.com>
Date: Mon, 30 Dec 2013 10:51:54 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf list: fix --raw-dump
References: <1386756980-23121-1-git-send-email-artagnon@gmail.com> <52A8D2DA.7050409@gmail.com> <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com> <20131216131954.GB2368@infradead.org> <CALkWK0ntHgX0vw+ZqkW54xMj18g4mJaaCwavtXGn3StRyJajWQ@mail.gmail.com>
In-Reply-To: <CALkWK0ntHgX0vw+ZqkW54xMj18g4mJaaCwavtXGn3StRyJajWQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:53:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:53:09,
	Serialize complete at 2013/12/30 10:53:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2013 05:11 AM, Ramkumar Ramachandra wrote:
> Arnaldo Carvalho de Melo wrote:
>> So is the patch below the one to apply? When these things happen, it
>> helps if you resubmit with a v2 in the subject line and then an explicit
>> Ack is provided, be it from, in this case, David, or Ramkumar could just
>> add it since David provided it in free form, ok?
> Is any action required on my part: should I resubmit this, or has it
> already been picked up?

Hi Ramkumar,
     I sent a patch set for enhancement of perf list recently,
[PATCH 0/8 V2] Enhancement for perf list.
<http://lkml.kernel.org/r/cover.1388416837.git.yangds.fnst@cn.fujitsu.com>.

  It contains a patch [6/8] is very similar with yours here. But I make it
works as a option for other argument,  such as hw, too. And I add
a signed-off-by Ramkumar and signed-off-by David in that patch.

Do you mind we turn to that thread to fix --raw-dump ??

Could you help to take a look at it??

Yang
>
> p.s- Sorry about the terribly late response; was on vacation.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

