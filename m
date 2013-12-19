Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3LSI4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:56:03 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48400 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3LSIz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:55:59 -0500
X-AuditID: 9c930179-b7bedae000000f15-c0-52b2b49d8351
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-11-git-send-email-namhyung@kernel.org>
	<52AEB87D.6020507@hitachi.com> <87fvptgpe0.fsf@sejong.aot.lge.com>
	<8738lsgwm2.fsf@sejong.aot.lge.com>
	<20131218152553.04c04042@gandalf.local.home>
	<20131218203423.GA11344@redhat.com>
Date: Thu, 19 Dec 2013 17:55:57 +0900
In-Reply-To: <20131218203423.GA11344@redhat.com> (Oleg Nesterov's message of
	"Wed, 18 Dec 2013 21:34:24 +0100")
Message-ID: <874n65fcde.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, 18 Dec 2013 21:34:24 +0100, Oleg Nesterov wrote:
> On 12/18, Steven Rostedt wrote:
>>
>> On Tue, 17 Dec 2013 09:16:37 +0900
>> Namhyung Kim <namhyung@kernel.org> wrote:
>>
>> > Hi Steve,
>> >
>> > Would you please review this and consider merging it?  It seems there's
>> > no more remaining issue and we want to make a progress on it. :)
>> >
>> > Oleg, Srikar, it'd be great if you could confirm it though.
>> >
>>
>> I'd feel better if we got some feedback from Oleg and Srikar too.
>
> Sorry, didn't have the time to review.
>
> I'll try very much to do this tomorrow. But I do not expect I will find
> something interesting, at first glance this version addresses all concerns
> I had.

Thanks in advance!  Please let me know if you find anything
interesting. :)

Thanks,
Namhyung
