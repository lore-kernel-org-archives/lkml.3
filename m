Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3CPJeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 05:34:07 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39576 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3CPJeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 05:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDHwgtm=to3WUj73d7q6cjJ7oG6capjUxvcpVk0wH-fbQ@mail.gmail.com>
References: <CAJd=RBDHwgtm=to3WUj73d7q6cjJ7oG6capjUxvcpVk0wH-fbQ@mail.gmail.com>
From: Raymond Jennings <shentino@gmail.com>
Date: Sat, 16 Mar 2013 02:33:23 -0700
Message-ID: <CAGDaZ_ryxdMBm44kotjKyCeFEFk3OURjHav3zVOcQNGwP_ZwAQ@mail.gmail.com>
Subject: Re: OOM triggered with plenty of memory free
To: Hillf Danton <dhillf@gmail.com>
Cc: Jonathan Woithe <jwoithe@atrad.com.au>,
        David Rientjes <rientjes@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 2:25 AM, Hillf Danton <dhillf@gmail.com> wrote:
>> Some system specifications:
>> - CPU: i7 860 at 2.8 GHz
>> - Mainboard: Advantech AIMB-780
>> - RAM: 4 GB
>> - Kernel: 2.6.35.11 SMP, 32 bit (kernel.org kernel, no patches applied)

> The highmem no longer holds memory with 64-bit kernel.

I don't really think that's a valid reason to dismiss problems with
32-bit though, as I still use it myself.

Anyway, to the parent poster, could you tell us more, such as how much
ram you had left free?

A printout of /proc/meminfo might help here.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
