Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128Ab3IDRIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:08:18 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54015 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3IDRIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:08:16 -0400
Message-ID: <522768F8.2040307@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 22:38:08 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <87mwntt8y0.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwntt8y0.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090416-4790-0000-0000-00000A24A2A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 11:38 AM, Namhyung Kim wrote:
> Hi Hemant,
>
> On Tue, 03 Sep 2013 13:06:40 +0530, Hemant Kumar Shaw wrote:
>> This series adds support to perf to list and probe into the SDT markers.
>> The first patch implements listing of all the SDT markers present in
>> the ELFs (executables or libraries). The SDT markers are present in the
>> .note.stapsdt section of the elf. That section can be traversed to list
>> all the markers. Recognition of markers follows the SystemTap approach.
>>
>> The second patch will allow perf to probe into these markers. This is
>> done by writing the marker name and its offset into the
>> uprobe_events file in the tracing directory.
>> Then, perf tools can be used to analyze perf.data file.
> First, thanks for your work!
>
> In fact, I was working on the same topic of support SDT markers.  But I
> started it by adding support for accessing arguments in uprobes [1].

I was thinking of adding support to SDT markers' arguments too!! I 
already have your patches and did some basic testing. I will add support 
to arguments in the next iteration of my patches.

> The patchset is floating around the list for now but I hope it'll get
> merged soon.  I guess you want to have it too :).

Of course, that would be great!

>
> Anyway, it'd great if you add me to CC next time.

Sure, will do that.

Thanks
Hemant
>
> Thanks,
> Namhyung
>
>
> [1] http://thread.gmane.org/gmane.linux.kernel/1555044
>

