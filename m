Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaAUIia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:38:30 -0500
Received: from 0106ds1-hvi.0.fullrate.dk ([90.184.84.98]:25995 "EHLO
	mail.knielsen-hq.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaAUIi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:38:27 -0500
From: Kristian Nielsen <knielsen@knielsen-hq.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GPF in aio_migratepage
References: <20131126032645.GA32301@redhat.com>
	<20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel>
	<20131126152337.GL15489@kvack.org>
	<87d2lh6h92.fsf@frigg.knielsen-hq.org>
	<529C5CA6.6090708@cn.fujitsu.com> <20131202174913.GA18853@redhat.com>
	<87ob4hu66n.fsf@frigg.knielsen-hq.org>
	<52AE6C4A.9080203@cn.fujitsu.com>
	<871u14ty2q.fsf@frigg.knielsen-hq.org>
	<20131222213443.GA6891@kvack.org>
	<87wqiwse81.fsf@frigg.knielsen-hq.org>
Date: Tue, 21 Jan 2014 09:38:23 +0100
In-Reply-To: <87wqiwse81.fsf@frigg.knielsen-hq.org> (Kristian Nielsen's
	message of "Sun, 22 Dec 2013 23:38:54 +0100")
Message-ID: <87a9epwwzk.fsf@frigg.knielsen-hq.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Nielsen <knielsen@knielsen-hq.org> writes:

> Benjamin LaHaise <bcrl@kvack.org> writes:
>
>> Linus just pushed out 3.13-rc5 that has changes to aio_migratepage() that 
>> should make it much more robust, as well as other fixes.  Can you please 
>> give it a spin as well and let me know if it works?  Thanks a bunch!
>
> Ok, will do.

JFYI, I have been running -rc5 (and later -rc7) for a month now without seeing
anything like this again. So hopefully the issue is solved.

 - Kristian.
