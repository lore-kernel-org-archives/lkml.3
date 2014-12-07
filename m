Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaLGU0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:26:12 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44238 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLGU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:26:11 -0500
MIME-Version: 1.0
In-Reply-To: <026301d00ed0$eb723020$c2569060$@alibaba-inc.com>
References: <026301d00ed0$eb723020$c2569060$@alibaba-inc.com>
Date: Mon, 8 Dec 2014 07:26:09 +1100
X-Google-Sender-Auth: 9q4sh-SToWM2Doz478aNCGaUcfU
Message-ID: <CABqErrEakrJN800zdCMJvmFk0j2-2LKXYpV1H1RkNtE5r5LE6g@mail.gmail.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler v0.450 with SMT nice support for linux-3.16
From: Con Kolivas <kernel@kolivas.org>
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2014 at 19:12, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
> Hey Con

Hi Hilf

>> This is to announce a resync and  update of the Brain Fuck Scheduler,
>> version 0.450 for the latest stable linux kernel.
>>
> [...]
>> The patch against linux-3.16(.x) is available here:
>> http://ck.kolivas.org/patches/bfs/3.0/3.16/3.16-sched-bfs-450.patch
>>
> $ grep -nr above_background_load  bfs/src
> bfs/src/3.16-sched-bfs-450.patch:689:+bool above_background_load(void);
> bfs/src/3.16-sched-bfs-450.patch:736:+static inline bool above_background_load(void)
> bfs/src/3.16-sched-bfs-450.patch:1665:+bool above_background_load(void)
>
> Would you please pin-point what is that routine used for?

This function used to be used with the VM tweaks that the -ck patchset
used to come with. I have since deprecated those VM tweaks but the
function remains in the scheduler. You're right to point it out and
I'll remove it when I resync with 3.18 (it's still in the BFS 458
patch for 3.17).

Thanks,
Con

> Thanks
> Hillf
>
