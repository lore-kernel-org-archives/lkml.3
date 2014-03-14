Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaCNClC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:41:02 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45164 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaCNClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <1394764620.21721.56.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1394762715-24272-1-git-send-email-chema@google.com>
	<1394764620.21721.56.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Thu, 13 Mar 2014 19:40:59 -0700
Message-ID: <CA+ZOOTP7OqyHvSz=ufisFF12hDo0g9C5SaE+a0e_+FvevRnbXw@mail.gmail.com>
Subject: Re: [PATCH] procfs: make smp_affinity values 0644
From: Chema Gonzalez <chema@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0444 maybe?

-Chema

On Thu, Mar 13, 2014 at 7:37 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2014-03-13 at 19:05 -0700, Chema Gonzalez wrote:
>> Includes:
>> - /proc/irq/default_smp_affinity
>> - /proc/irq/*/smp_affinity
>> - /proc/irq/*/smp_affinity_list
>>
>> Users can distill the same information by reading /proc/interrupts.
>>
>> Signed-off-by: Chema Gonzalez <chema@google.com>
>> ---
>
> Seems good to me, but what about affinity_hint ?
>
>
