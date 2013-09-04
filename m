Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055Ab3IDGnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:43:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45175 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3IDGnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:43:15 -0400
X-AuditID: 9c93017e-b7c76ae000003897-04-5226d68150c2
From: Namhyung Kim <namhyung@kernel.org>
To: Hemant <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com,
        Aravinda Prasad <aravinda@linux.vnet.ibm.com>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora>
	<20130903073655.4793.20013.stgit@hemant-fedora>
	<52259B97.9010701@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 15:43:13 +0900
In-Reply-To: <52259B97.9010701@linux.vnet.ibm.com> (Hemant's message of "Tue,
	03 Sep 2013 13:49:35 +0530")
Message-ID: <87eh95t7cu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Sep 2013 13:49:35 +0530, Hemant wrote:
> On 09/03/2013 01:06 PM, Hemant Kumar wrote:
>> This patch will enable perf to list all the sdt markers present
>> in an elf file. The markers are present in the .note.stapsdt section
>> of the elf. We can traverse through this section and collect the
>> required info about the markers.
>> This hasn't been thoroughly tested with the other
>> options of perf.
>> ----
>> Usage :
>> ./perf probe --list -x /lib64/libc.so.6
>
> There is a mismatch between usage and the patch here. This should be:
> perf probe --list -S /lib64/libc.so.6

I guess it should be

  perf probe -S -x /lib64/libc.so.6


Thanks,
Namhyung
