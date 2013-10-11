Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3JKSmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:42:54 -0400
Received: from natasha.panasas.com ([67.152.220.90]:59467 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3JKSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:42:52 -0400
Message-ID: <5258469F.9070108@panasas.com>
Date: Fri, 11 Oct 2013 11:42:39 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: initcall calibrate_xor_blocks returned with preemption imbalance
References: <20131010090217.GB2541@localhost> <525710F3.1000209@panasas.com> <20131011012936.GB11191@localhost>
In-Reply-To: <20131011012936.GB11191@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.67.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 06:29 PM, Fengguang Wu wrote:
> 
> I'm running kernel build/boot/performance tests for *all* the public
> kernel git trees I'm aware of. If this is not necessary for your tree
> or some of the branches, sorry I can remove them from the test pool.
> 
>> I can see below:
>> 	Merge 'open-osd/exofs_ioctl' into devel-hourly-2013101007
>>

OK then there you have it then. Yes exofs_ioctl is a testing branch
that I also use with UML. And there for must carry this unfinished
patch.

Thankyou for the bisect. I will take this crash report and put
it on my todo for fixing the xor stuckness.

Have a good day
Boaz
