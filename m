Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3ICPYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:24:40 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:32996 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3ICPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:24:39 -0400
Message-ID: <5225FF2D.3010700@linux.vnet.ibm.com>
Date: Tue, 03 Sep 2013 20:54:29 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com> <5225E2C5.3080001@linux.vnet.ibm.com> <20130903142159.GA27740@gmail.com>
In-Reply-To: <20130903142159.GA27740@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090315-1618-0000-0000-00000490038C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:51 PM, Ingo Molnar wrote:
> * Hemant <hkshaw@linux.vnet.ibm.com> wrote:
>
>> Here is an overview and a high-level-description:
> Thanks, looks like a pretty useful feature - especially if SDT probes are
> already widely present in various server binaries on a typical Linux
> distro (are they?).

Yes, as far as I know, SDT markers are present in these binaries on a 
typical linux distro.

>
> Would be nice to stick some or all of that info into
> tools/perf/Documentation/sdt-probes.txt, and put the most useful part of
> that info into the man page as well - or something like that.
>
> Thanks,
>
> 	Ingo
>

Yes, will write the required documentation.

Thanks
Hemant Kumar Shaw

