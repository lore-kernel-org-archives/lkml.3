Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3BEKtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:49:49 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:54923 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3BEKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:49:46 -0500
MIME-Version: 1.0
In-Reply-To: <87lib3gunm.fsf@blp.benpfaff.org>
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
	<20130204081920.00e9f22e@nehalam.linuxnetplumber.net>
	<87lib3gunm.fsf@blp.benpfaff.org>
Date: Tue, 5 Feb 2013 18:49:45 +0800
Message-ID: <CAM_iQpXSv7ddFtF53JGu=QdaNgY7c4O9Wuq4PmVRczTBiE_rSg@mail.gmail.com>
Subject: Re: No sysfs directory for openvswitch module when built-in
From: Cong Wang <xiyou.wangcong@gmail.com>
To: blp@cs.stanford.edu
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jesse Gross <jesse@nicira.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 2:08 PM, Ben Pfaff <blp@cs.stanford.edu> wrote:
> Stephen Hemminger <stephen@networkplumber.org> writes:
>
>> On Tue, 29 Jan 2013 22:15:18 +0800
>> Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>>> Hello, Rusty, Jesse,
>>>
>>> I met an interesting problem when I compile openvswitch module as a
>>> built-in (actually I compile ALL kernel modules as built-in), there is
>>> no /sys/module/openvswitch/ directory created by the kernel in this
>>> case.
>>>
>>> What's worse, the user-space init script thinks openvswitch module is
>>> not loaded by checking the exist of this directory, therefore refuses
>>> to start.
>>
>> Shouldn't the OVS init script be testing for some other API.
>
> I agree that's a bug in the OVS init script.  I will fix it.

Thanks for taking care of it, Ben!
