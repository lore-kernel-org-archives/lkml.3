Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3BDQTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:19:35 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39205 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3BDQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:19:34 -0500
Date: Mon, 4 Feb 2013 08:19:20 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jesse Gross <jesse@nicira.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: No sysfs directory for openvswitch module when built-in
Message-ID: <20130204081920.00e9f22e@nehalam.linuxnetplumber.net>
In-Reply-To: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 22:15:18 +0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> Hello, Rusty, Jesse,
> 
> I met an interesting problem when I compile openvswitch module as a
> built-in (actually I compile ALL kernel modules as built-in), there is
> no /sys/module/openvswitch/ directory created by the kernel in this
> case.
> 
> What's worse, the user-space init script thinks openvswitch module is
> not loaded by checking the exist of this directory, therefore refuses
> to start.

Shouldn't the OVS init script be testing for some other API.

