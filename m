Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab3ENShW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:37:22 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47640 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab3ENShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:37:21 -0400
MIME-Version: 1.0
In-Reply-To: <CALZVapkH9KN=w_+zVNc2Bgza_HqojA8xt8R+iTeas9x7s5R06Q@mail.gmail.com>
References: <CALZVapkH9KN=w_+zVNc2Bgza_HqojA8xt8R+iTeas9x7s5R06Q@mail.gmail.com>
From: Javier Domingo <javierdo1@gmail.com>
Date: Tue, 14 May 2013 20:36:59 +0200
Message-ID: <CALZVapn-3CLWeScaMcB9kmao_OfSR6_SvRm9_zCgxR7p3sygqQ@mail.gmail.com>
Subject: Re: Kernel OOPS using auditd Debian 3.2 on a /sys file audit
To: linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't get any reply, is this mailing list still valid, or should I
ask elsewhere? (this is a ping message)

Javier Domingo


2013/5/2 Javier Domingo <javierdo1@gmail.com>:
> Hi,
>
> I am currently having problems with the cpu scaling (something is
> touching the /sys/devices/system/cpu/cpu?/cpufreq/scaling_max_freq),
> and I decided to use inotify to seek if something was being changed or
> not.
>
> This gave no problems to me, but something is writing just before me,
> and I can't know from the inotifywait cmd who. Then, I found auditdl,
> so I put this command onto it:
>
> # auditctl -w /sys/devices/system/cpu/cpu?/cpufreq/scaling_max_freq
>
> And just after this, this totally blocking OOPS was triggered:
> [ 5072.685483] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000038
> [ 5072.714302] IP: [<ffffffff8114f06c>] sysfs_dentry_revalidate+0x9/0xa2
> [ 5072.741249] PGD 12eca4067 PUD 12ec62067 PMD 0
> [ 5072.768102] Oops: 0000 [#1] SMP
>
> I tried to make sysrq, but didn't work. I have repeated several times
> this and it always crashes. I am attaching the photo of the second
> time because it is much longer than the second one.
>
> Hope this helps on something!
>
> Javier Domingo
