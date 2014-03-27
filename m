Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaC0Pbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:31:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51092 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaC0Pbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:31:36 -0400
Message-ID: <53344452.7090107@oracle.com>
Date: Thu, 27 Mar 2014 11:31:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG: Bad page state in process ksmd
References: <5332EE97.4050604@oracle.com> <alpine.LSU.2.11.1403270806340.4269@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1403270806340.4269@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 11:21 AM, Hugh Dickins wrote:
> I've thought about this some, and slept on it, but don't yet see
> how it comes about.  I'll have to come back to it later.
>
> Was it a one-off, or do you find it fairly easy to reproduce?
>
> If the latter, it would be interesting to know if it comes from
> recent changes or not.  mm/mlock.c does appear to have been under
> continuous revision for several releases (but barely changed in next).

I can't say it's easy to reproduce but it did happen 5-6 times at this point.

As far as I can tell there were no big changes in trinity for the last week
or so while we were in lsf/mm, and this issue being reproducible makes me
believe it has something to do with recent changes to mm code.


Thanks,
Sasha
