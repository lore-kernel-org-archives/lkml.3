Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3EVFLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:11:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59840 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3EVFLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:11:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,719,1363104000"; 
   d="scan'208";a="7330659"
Message-ID: <519C543E.9040401@cn.fujitsu.com>
Date: Wed, 22 May 2013 13:14:38 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org> <517F7110.6000705@cn.fujitsu.com> <518B645C.10408@cn.fujitsu.com> <CAE9FiQWPFL0qagAmkcyj_XfjWQtONtomwQPAimKUm+nJi5dHTw@mail.gmail.com>
In-Reply-To: <CAE9FiQWPFL0qagAmkcyj_XfjWQtONtomwQPAimKUm+nJi5dHTw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 13:10:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 13:10:26,
	Serialize complete at 2013/05/22 13:10:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 02:24 AM, Yinghai Lu wrote:
......

>> If you have any thinking of this patch-set, please let me know.
>
> Talked to HPA, and he will put my patchset into tip/x86/mm after v3.10-rc1.
>
> after that we can work on put pagetable on local node for hotadd path.
>

Hi,

It is Linux v3.10-rc2 now. But I didn't find this patch-set merged into
tip/x86/mm. was it merged to somewhere else, or we have any other plan
to push ?

By the way, I have done some tests for this patch-set, and the test results
have been sent. Please refer to:
https://lkml.org/lkml/2013/4/30/45

Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>

Thanks. :)

