Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaBCTfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:35:40 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54095 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaBCTfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+ydwtpmFbhkck9z8G7tfHQZW+4rWSepQMgPURqVCwrZ77v2bA@mail.gmail.com>
References: <CA+ydwtrWCgi=v7v=8yjNMV37Aa4ua9zbqYM5_uUdQrLSQt+VEw@mail.gmail.com>
	<1391201873.28432.86.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+ydwtpmFbhkck9z8G7tfHQZW+4rWSepQMgPURqVCwrZ77v2bA@mail.gmail.com>
Date: Mon, 3 Feb 2014 21:35:24 +0200
Message-ID: <CA+ydwto5CTDSED=pZ_DfAZyh6Jx7xKJafRuDFUtV4ZZCb70ULA@mail.gmail.com>
Subject: Re: BUG ip_dst_cache (Not tainted): Poison overwritten
From: Tommi Rantala <tt.rantala@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-01 Tommi Rantala <tt.rantala@gmail.com>:
> 2014-01-31 Eric Dumazet <eric.dumazet@gmail.com>:
>> On Fri, 2014-01-31 at 22:11 +0200, Tommi Rantala wrote:
>>> Hello,
>>>
>>> Hit this while fuzzing v3.13-9218-g0e47c96 with trinity in a qemu
>>> virtual machine.
>>>
>>> Tommi
>>
>> Hi Tommi
>>
>> Could you please try the following fix ?
>
> Thanks, giving this a spin. This does not reproduce very easily with
> Trinity, I'll let you know if anything blows up.

Looking good after two days of fuzzing in several virtual machines.
The bug has not been reproduced, and no other ill effects visible.

Thanks!

Tommi
