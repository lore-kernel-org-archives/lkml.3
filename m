Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161119AbaJ3QDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:03:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48036 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284AbaJ3QDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:03:35 -0400
Message-ID: <5452612C.5090609@oracle.com>
Date: Thu, 30 Oct 2014 12:02:52 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Michal Hocko <mhocko@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, peterz@infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: initialize variable for mem_cgroup_end_page_stat
References: <1414633464-19419-1-git-send-email-sasha.levin@oracle.com> <20141030082712.GB4664@dhcp22.suse.cz> <54523DDE.9000904@oracle.com> <20141030141401.GA24520@phnom.home.cmpxchg.org> <54524A2F.5050907@oracle.com> <20141030150624.GA24818@phnom.home.cmpxchg.org>
In-Reply-To: <20141030150624.GA24818@phnom.home.cmpxchg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 11:06 AM, Johannes Weiner wrote:
>> You're using that value as soon as you are passing it to a function, it
>> > doesn't matter what happens inside that function.
> It's copied as part of the pass-by-value protocol, but we really don't
> do anything with it.  So why does it matter?

Because it's undefined behaviour, which gives your compiler a license to
do whatever it wants?


Thanks,
Sasha

