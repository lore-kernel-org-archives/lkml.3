Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3EUHKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:10:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39758 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab3EUHKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:10:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,712,1363104000"; 
   d="scan'208";a="7321421"
Message-ID: <519B1E75.5040401@cn.fujitsu.com>
Date: Tue, 21 May 2013 15:12:53 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] numa, mm, memory-hotplug: Do not allocate pagetable
 to local node with MEMORY_HOTREMOVE enabled.
References: <1368705021-24396-1-git-send-email-tangchen@cn.fujitsu.com> <CAOJsxLEhSM1foG=fUcGyz1rvfPPirh4jW+dZuhO6ap5oKFk5ug@mail.gmail.com>
In-Reply-To: <CAOJsxLEhSM1foG=fUcGyz1rvfPPirh4jW+dZuhO6ap5oKFk5ug@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 15:08:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 15:08:43,
	Serialize complete at 2013/05/21 15:08:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 05/21/2013 03:02 PM, Pekka Enberg wrote:
......
>
> Ugh. Special-casing for CONFIG_MEMORY_HOTPLUG is just begging for
> trouble. Were you able to determine which commit broke memory
> hot-remove?

Please refer to the following patch-set.
https://lkml.org/lkml/2013/4/11/829

patch21 and patch22 will allocate pagetable to local, which may cause
memory hot-remove fail.

But this patch-set is not in the mainline now.

Thanks. :)


