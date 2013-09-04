Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab3IDSAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:00:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34312 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3IDSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:00:10 -0400
Message-ID: <52277521.5020800@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 23:30:01 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [PATCH 2/2] Support to perf to probe on SDT markers:
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073703.4793.32779.stgit@hemant-fedora> <8761uht6jk.fsf@sejong.aot.lge.com> <5226EAEA.1010606@hitachi.com>
In-Reply-To: <5226EAEA.1010606@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090417-5140-0000-0000-000003C726D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:40 PM, Masami Hiramatsu wrote:
> (2013/09/04 16:00), Namhyung Kim wrote:
>> On Tue, 03 Sep 2013 13:07:03 +0530, Hemant Kumar wrote:
>>> This patch enables perf to probe on the marker name specified on the command line.
>> It looks like you didn't consider prelinked libraries.  You need to check
>> the address of .stapsdt.base section too.  And obviously this patch
>> ignores any argument the SDT has which I think pretty important info.
>> But we can add it later once the uprobes arg fetch patches are in.
> Agreed, I'd like to see the argument support afterward.
> Thanks!
>

Will add the argument support in the next iteration.

Thanks
Hemant

