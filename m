Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaLONQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:16:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43537 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaLONQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:16:55 -0500
Message-ID: <548EDF14.3090306@oracle.com>
Date: Mon, 15 Dec 2014 08:16:04 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141212203417.GE25340@linux.vnet.ibm.com> <548B5CEC.1040607@oracle.com> <20141213083055.GI32572@gmail.com> <548C60FF.9020607@oracle.com> <20141213180752.GI25340@linux.vnet.ibm.com> <20141214175007.GA6927@linux.vnet.ibm.com> <548E214D.6040706@oracle.com> <20141215001123.GK5310@linux.vnet.ibm.com> <548E374D.1040003@oracle.com> <20141215063331.GL5310@linux.vnet.ibm.com> <20141215125641.GA12673@linux.vnet.ibm.com>
In-Reply-To: <20141215125641.GA12673@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 07:56 AM, Paul E. McKenney wrote:
> And maybe it would help if I did the CONFIG_TASKS_RCU=n case as well as
> the CONFIG_TASKS_RCU=y case.  Please see below for an updated patch.

I do have CONFIG_TASKS_RCU=y


Thanks,
Sasha
