Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbaKSTO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:14:29 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:54094 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaKSTO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:14:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141119190824.GM5050@linux.vnet.ibm.com>
References: <20141119100946.GB4163@osiris>
	<20141119190824.GM5050@linux.vnet.ibm.com>
Date: Wed, 19 Nov 2014 14:14:27 -0500
X-Google-Sender-Auth: kcD51o896-FFNYUIkwQbmyFReHQ
Message-ID: <CA+5PVA5q+XASnm5Cejde_4c-isYsuPJzd5C=ZvmRw_EEGCgVJA@mail.gmail.com>
Subject: Re: rcu warning caused by [sched: Fix race between task_group and sched_task_group]
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Kirill Tkhai <ktkhai@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 2:08 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Nov 19, 2014 at 11:09:46AM +0100, Heiko Carstens wrote:
>> Hi Kirill,
>>
>> the problem below has already been reported here:
>> https://lkml.org/lkml/2014/11/11/505
>>
>> but seems there is still no fix available upstream?
>> Would be good to have it soon, since this basically renders lockdep unusable.
>
> This one fixes this bug for me:
>
> https://lkml.org/lkml/2014/11/4/613

Yes.  It's still not in Linus' tree.

josh
