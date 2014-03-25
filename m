Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaCYSAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:00:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37314 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaCYSAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:00:50 -0400
Message-ID: <5331C3FD.4070704@oracle.com>
Date: Tue, 25 Mar 2014 11:59:25 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, gnomes@lxorguk.ukuu.org.uk, riel@redhat.com,
        snorcht@gmail.com, dhowells@redhat.com, luto@amacapital.net,
        daeseok.youn@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com> <20140325174624.GA15527@redhat.com>
In-Reply-To: <20140325174624.GA15527@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 11:46 AM, Oleg Nesterov wrote:
> On 03/25, Khalid Aziz wrote:
>>
>>   fs/proc/base.c                                     |  89 ++++++++
>
> This code can be simplified, but the real question is why do we need it.
>
> Just add PR_SET_PREEMPT_DELAY ?
>
> Oleg.
>

I like this idea! Thanks.

--
Khalid
