Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3FKPpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:45:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40123 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3FKPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:45:10 -0400
Message-ID: <51B745F9.9080609@oracle.com>
Date: Tue, 11 Jun 2013 11:44:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com> <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com> <51B62F6B.8040308@oracle.com> <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com> <51B67553.6020205@oracle.com> <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com> <51B72323.8040207@oracle.com> <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com> <51B73F38.6040802@kernel.org> <0000013f33d58923-88767793-2187-476d-b500-dba3c22607aa-000000@email.amazonses.com>
In-Reply-To: <0000013f33d58923-88767793-2187-476d-b500-dba3c22607aa-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 11:23 AM, Christoph Lameter wrote:
> On Tue, 11 Jun 2013, Pekka Enberg wrote:
>
>> So you're OK with going forward with Sasha's patch? It's needed
>> because __GFP_NOWARN was specifically added there to fix this
>> issue earlier.
>
> Why dont we fix the call site to use vmalloc instead for larger allocs?
>

We should probably be doing both.


Thanks,
Sasha
