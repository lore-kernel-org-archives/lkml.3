Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaJQSG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:06:58 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48363 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaJQSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:06:57 -0400
Date: Fri, 17 Oct 2014 14:06:56 -0400 (EDT)
From: Ulrich Obergfell <uobergfe@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <670899746.71006536.1413569216696.JavaMail.zimbra@redhat.com>
In-Reply-To: <20141014145612.GA135937@redhat.com>
References: <1413210762-4532-1-git-send-email-uobergfe@redhat.com> <20141014145612.GA135937@redhat.com>
Subject: Re: [PATCH 0/1] watchdog: parameters to control hard and soft
 lockup detector individually
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF22 (Linux)/8.0.6_GA_5922)
Thread-Topic: watchdog: parameters to control hard and soft lockup detector individually
Thread-Index: 9q322vs2IMg6J7D/qO9ZL54PgL2Iog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ----- Original Message -----
> From: "Don Zickus" <dzickus@redhat.com>
> To: "Ulrich Obergfell" <uobergfe@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Tuesday, October 14, 2014 4:56:12 PM
> Subject: Re: [PATCH 0/1] watchdog: parameters to control hard and soft lockup detector individually
>
> On Mon, Oct 13, 2014 at 04:32:41PM +0200, Ulrich Obergfell wrote:
>> This post follows up to https://lkml.org/lkml/2014/8/11/329.
>> During the discussion of that patch, Ingo Molnar commented in
>> https://lkml.org/lkml/2014/8/18/577.
>> 
>>  "The softlockup and hardlockup detection control variables 
>>   should be in separate flags, inside and outside the kernel - 
>>   they (should) not relate to each other."
>> 
>> Please refer to [PATCH 1/1] for a description of the proposed
>> changes of the 'user interface' in /proc/sys/kernel and kernel
>> command line parameters.
>
> Hi Uli,
>
> Andrew just posted some of your other patches upstream for v3.18-rc1.
> Let's try to rebase these changes on top of those and see what it looks
> like.
>
> Cheers,
> Don

Don,

I rebased the changes and posted a 'version 2' series in

  https://lkml.org/lkml/2014/10/17/340

Regards,

Uli
