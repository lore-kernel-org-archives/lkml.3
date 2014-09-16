Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaIPI7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:59:35 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46123 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaIPI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:59:32 -0400
Date: Tue, 16 Sep 2014 10:59:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>, Pei Feiyue <peifeiyue@huawei.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] kprobes/x86: opt: free optinsn cache when range check
 fails
Message-ID: <20140916085927.GB4907@gmail.com>
References: <1406550019-70935-1-git-send-email-wangnan0@huawei.com>
 <53D6FC38.8070801@hitachi.com>
 <53FDCBF1.2020606@huawei.com>
 <53FDDF08.5090604@hitachi.com>
 <5416403D.8010504@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5416403D.8010504@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang Nan <wangnan0@huawei.com> wrote:

> Hi Ingo and Masami,
> 
> I still unable to find this bugfix in mainline code. Is there any problem?

It's in tip:perf/urgent, on its way to Linus.

Thanks,

	Ingo
