Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965879Ab3FUFV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:21:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53664 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3FUFVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:21:55 -0400
Message-ID: <51C3E276.8030804@zytor.com>
Date: Thu, 20 Jun 2013 22:19:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org,
        tj@kernel.org, trenn@suse.de, yinghai@kernel.org, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part1 PATCH v5 00/22] x86, ACPI, numa: Parse numa info earlier
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 06:02 AM, Tang Chen wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> No offence, just rebase and resend the patches from Yinghai to help
> to push this functionality faster.
> Also improve the comments in the patches' log.
> 

So we need a new version of this which addresses the build problems and
the feedback from Tejun... and it would be good to get that soon, or
we'll be looking at 3.12.

Since the merge window is approaching quickly, is there a meaningful
subset that is ready now?

	-hpa


