Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaGOEfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:35:36 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46635 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaGOEfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <53C396D3.9000600@vodafone.de>
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
	<20140710222423.GA14219@gmail.com>
	<019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
	<20140711211850.GU1870@gmail.com>
	<019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
	<20140713035535.GB5301@gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
	<20140713164901.GB10624@gmail.com>
	<53C396D3.9000600@vodafone.de>
Date: Tue, 15 Jul 2014 14:35:19 +1000
Message-ID: <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
From: Dave Airlie <airlied@gmail.com>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: Jerome Glisse <j.glisse@gmail.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2014 18:37, Christian König <deathsimple@vodafone.de> wrote:
>> I vote for HSA module that expose ioctl and is an intermediary with the
>> kernel driver that handle the hardware. This gives a single point for
>> HSA hardware and yes this enforce things for any hardware manufacturer.
>> I am more than happy to tell them that this is it and nothing else if
>> they want to get upstream.
>
> I think we should still discuss this single point of entry a bit more.
>
> Just to make it clear the plan is to expose all physical HSA capable devices
> through a single /dev/hsa device node to userspace.

This is why we don't design kernel interfaces in secret foundations,
and expect anyone to like them.

So before we go any further, how is this stuff planned to work for
multiple GPUs/accelerators?

Do we have a userspace to exercise this interface so we can see how
such a thing would look?

Dave.
