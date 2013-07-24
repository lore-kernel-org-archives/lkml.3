Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab3GXAkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:40:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26409 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab3GXAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:40:16 -0400
Message-ID: <51EF222D.9070909@oracle.com>
Date: Tue, 23 Jul 2013 20:39:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>,
        acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
In-Reply-To: <20130723225150.GT6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 06:51 PM, Andi Kleen wrote:
> On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
>> >
>> >I hate having to justify why breaking the ABI is unacceptable.
> Well it's a testing ABI, so we can do changes to it.

The testing ABI has a simple policy about changes:

	The interface can be changed to add new features, but the
	current interface will not break by doing this, unless grave
	errors or security problems are found in them.

It's probably fine to change a testing ABI once in a while, but when things
like trinity start breaking that often due to ABI changes in the same exact
place, that's too much IMO.


Thanks,
Sasha
