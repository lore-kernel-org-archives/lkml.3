Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3KFIes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:34:48 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64922 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3KFIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:34:47 -0500
X-AuditID: 9c93017e-b7c9fae00000057d-6b-5279ff25510d
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
	<87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <87mwlj1tm7.fsf@sejong.aot.lge.com>
	<20131105163341.GB2460@redhat.com>
Date: Wed, 06 Nov 2013 17:34:45 +0900
In-Reply-To: <20131105163341.GB2460@redhat.com> (Oleg Nesterov's message of
	"Tue, 5 Nov 2013 17:33:41 +0100")
Message-ID: <878ux2x716.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 17:33:41 +0100, Oleg Nesterov wrote:
> On 11/05, Namhyung Kim wrote:
>>
>> On Mon, 4 Nov 2013 17:22:29 +0100, Oleg Nesterov wrote:
>> >
>> > So probably I was wrong and this all needs more thinking. Damn.
>>
>> :)
>
> Don't laugh at me ;)

:)

(And now I'm feeling guilty..)

>
>> > Perhaps we really need to pass @file/offset, but it is not clear what
>> > we can do with bss/anon-mapping.
>>
>> The @file/offset should work with bss since data in bss is accessed via
>> an offset in the program,
>
> Yes, yes, but it is still not clear to me how we can identify the "right"
> vma which doesn't cover the .bss address but can be used to calculate the
> offset.

Yes, that's the open problem for the cross-fetch.

Thanks,
Namhyung
