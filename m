Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970AbaEaAMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:12:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48303 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbaEaAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:12:22 -0400
Message-ID: <53891E3F.7060508@oracle.com>
Date: Fri, 30 May 2014 20:11:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Jet Chen <jet.chen@intel.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
References: <538808FD.3060707@intel.com> <20140530155051.GD2419@quack.suse.cz> <20140530161647.GD11096@twins.programming.kicks-ass.net> <20140530161948.GZ13658@twins.programming.kicks-ass.net> <20140530165810.GE2419@quack.suse.cz> <20140530172327.GF2419@quack.suse.cz> <20140530172420.GA28291@quack.suse.cz>
In-Reply-To: <20140530172420.GA28291@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:24 PM, Jan Kara wrote:
>   Now with the attachment... :)

Jan, I suspect that the issue Jet has reported is different from mine.

Your patch (or even removing all of print_PIC() didn't solve the issue
I've reported.


Thanks,
Sasha
