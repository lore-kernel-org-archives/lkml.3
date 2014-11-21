Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaKUWAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:00:49 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42578 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaKUWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:00:47 -0500
Message-ID: <546FB60A.8040005@redhat.com>
Date: Fri, 21 Nov 2014 23:00:42 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Tang Chen <tangchen@cn.fujitsu.com>
CC: Takashi Iwai <tiwai@suse.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tiejun Chen <tiejun.chen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: x86: fix access memslots w/o hold srcu read lock
References: <1414912063-10923-1-git-send-email-wanpeng.li@linux.intel.com> <5461A021.8000305@cn.fujitsu.com> <20141113233903.GA26686@kernel> <546EDEB5.4070809@cn.fujitsu.com> <20141121063050.GA14377@kernel>
In-Reply-To: <20141121063050.GA14377@kernel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/11/2014 07:30, Wanpeng Li wrote:
> I test it on the other guy's Ivytown and take advantage of the qemu command 
> line which he used, so I forget the accurate command line which used that day.
> 
> Paolo also reproduce the bug, Paolo, ping.

It also reproduced always for me with a debug kernel from Fedora.

Paolo
