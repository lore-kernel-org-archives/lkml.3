Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3FCF7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:59:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45641 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3FCF7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:59:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,791,1363104000"; 
   d="scan'208";a="7443022"
Message-ID: <51AC3142.4000104@cn.fujitsu.com>
Date: Mon, 03 Jun 2013 14:01:38 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org> <517F7110.6000705@cn.fujitsu.com> <518B645C.10408@cn.fujitsu.com> <CAE9FiQWPFL0qagAmkcyj_XfjWQtONtomwQPAimKUm+nJi5dHTw@mail.gmail.com> <519C543E.9040401@cn.fujitsu.com> <519C552E.7050700@zytor.com>
In-Reply-To: <519C552E.7050700@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 13:57:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 13:57:09,
	Serialize complete at 2013/06/03 13:57:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi HPA,

Would you please tell me if this patch-set has been merged
into any tree or branch ?

If not merged, I'll rebased it to the latest kernel and
resend it again. Hope the rebasing will help to push this
patch-set.

Thanks. :)

On 05/22/2013 01:18 PM, H. Peter Anvin wrote:
> Sorry, just have been swamped since -rc1 came out.
>
> 	-hpa
>
>
