Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaD1LeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaD1LeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:34:23 -0400
Message-ID: <535E3CB9.9070709@redhat.com>
Date: Mon, 28 Apr 2014 13:34:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
References: <534B930A.4070507@intel.com> <535E2054.8050805@redhat.com> <535E254A.4020500@intel.com>
In-Reply-To: <535E254A.4020500@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/04/2014 11:54, Jet Chen ha scritto:
>>> >> We noticed the below kernel BUG on
>>> >>
>>> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> >
>> > What commit?
>> >
> This one,
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> commit 93c4adc7afedf9b0ec190066d45b6d67db5270da
> Author:     Paolo Bonzini <pbonzini@redhat.com>
> AuthorDate: Wed Mar 5 23:19:52 2014 +0100
> Commit:     Paolo Bonzini <pbonzini@redhat.com>
> CommitDate: Mon Mar 17 12:21:39 2014 +0100
>
>       KVM: x86: handle missing MPX in nested virtualization
>
>
> BTW, the same issue has been reported by Fengguang last month.
>
> https://lkml.org/lkml/2014/3/26/200

It should have been fixed already by commit 920c83778569 (KVM: vmx: fix 
MPX detection, 2014-03-26).  That's why I was confused, I thought it was 
for a recent commit on Linus's master branch.

Paolo
