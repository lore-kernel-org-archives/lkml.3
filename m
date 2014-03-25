Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaCYXaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:30:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16997 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaCYXaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:30:22 -0400
Message-ID: <5332115B.5060309@oracle.com>
Date: Tue, 25 Mar 2014 17:29:31 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <1395788467.2480.6.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1395788467.2480.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 05:01 PM, Davidlohr Bueso wrote:
> Good timing! The topic came up just yesterday in LSF/MM. This
> functionality is on the wish list for both facebook and postgres.
>

Thanks for letting me know. I am glad to hear of others who need this 
functionality. Did you happen to catch the names of folks at facebook 
and postgres that are interested in this? I would like to work with them 
to make sure what I do works for them as well.

--
Khalid
