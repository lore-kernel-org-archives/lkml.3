Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3BEO2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:28:31 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36548 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3BEO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:28:28 -0500
MIME-Version: 1.0
In-Reply-To: <87boc0liug.fsf@rustcorp.com.au>
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
	<87boc0liug.fsf@rustcorp.com.au>
Date: Tue, 5 Feb 2013 22:28:27 +0800
Message-ID: <CAM_iQpWOKTrG2_8NVTd73AvLt3mcYGLisSTdHprStQ=dABSVgQ@mail.gmail.com>
Subject: Re: No sysfs directory for openvswitch module when built-in
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jesse Gross <jesse@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 1:59 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>> Hello, Rusty, Jesse,
>>
>> I met an interesting problem when I compile openvswitch module as a
>> built-in (actually I compile ALL kernel modules as built-in), there is
>> no /sys/module/openvswitch/ directory created by the kernel in this
>> case.
> ...
>> What's worse, the user-space init script thinks openvswitch module is
>> not loaded by checking the exist of this directory, therefore refuses
>> to start.
>
> We only know built-in "modules" exist if we see a parameter or version
> which mention them.  Looking for /sys/module/openvswitch/ is almost as
> flawed as looking in /proc/modules.

You are right. Ben will fix the openvswitch init script.

Thanks for your reply!
