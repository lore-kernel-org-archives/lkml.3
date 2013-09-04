Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab3IDRkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:40:11 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36725 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763205Ab3IDRkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:40:09 -0400
Message-ID: <52277073.4090500@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 23:10:03 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com,
        Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora> <52259B97.9010701@linux.vnet.ibm.com> <87eh95t7cu.fsf@sejong.aot.lge.com>
In-Reply-To: <87eh95t7cu.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090417-2000-0000-0000-00000D96C4C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 12:13 PM, Namhyung Kim wrote:
> On Tue, 03 Sep 2013 13:49:35 +0530, Hemant wrote:
>> On 09/03/2013 01:06 PM, Hemant Kumar wrote:
>>> This patch will enable perf to list all the sdt markers present
>>> in an elf file. The markers are present in the .note.stapsdt section
>>> of the elf. We can traverse through this section and collect the
>>> required info about the markers.
>>> This hasn't been thoroughly tested with the other
>>> options of perf.
>>> ----
>>> Usage :
>>> ./perf probe --list -x /lib64/libc.so.6
>> There is a mismatch between usage and the patch here. This should be:
>> perf probe --list -S /lib64/libc.so.6
> I guess it should be
>
>    perf probe -S -x /lib64/libc.so.6

Yes, missed the -x option.

Thanks
Hemant

>
>
> Thanks,
> Namhyung
>

