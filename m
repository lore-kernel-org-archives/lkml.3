Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaJNO4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbaJNO4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:56:13 -0400
Date: Tue, 14 Oct 2014 10:56:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ulrich Obergfell <uobergfe@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] watchdog: parameters to control hard and soft lockup
 detector individually
Message-ID: <20141014145612.GA135937@redhat.com>
References: <1413210762-4532-1-git-send-email-uobergfe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413210762-4532-1-git-send-email-uobergfe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:32:41PM +0200, Ulrich Obergfell wrote:
> This post follows up to https://lkml.org/lkml/2014/8/11/329.
> During the discussion of that patch, Ingo Molnar commented in
> https://lkml.org/lkml/2014/8/18/577.
> 
>  "The softlockup and hardlockup detection control variables 
>   should be in separate flags, inside and outside the kernel - 
>   they (should) not relate to each other."
> 
> Please refer to [PATCH 1/1] for a description of the proposed
> changes of the 'user interface' in /proc/sys/kernel and kernel
> command line parameters.

Hi Uli,

Andrew just posted some of your other patches upstream for v3.18-rc1.
Let's try to rebase these changes on top of those and see what it looks
like.

Cheers,
Don
