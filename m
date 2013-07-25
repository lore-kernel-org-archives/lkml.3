Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3GYXQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:16:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49494 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab3GYXQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:16:11 -0400
Message-ID: <51F1B17F.30902@ti.com>
Date: Thu, 25 Jul 2013 19:15:11 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com> <20130629152959.GB31339@mtj.dyndns.org> <20130629172123.GA3353@n2100.arm.linux.org.uk> <20130629175743.GA382@mtj.dyndns.org> <CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com> <20130629195549.GE3353@n2100.arm.linux.org.uk> <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com> <51D18DBA.6090608@ti.com> <51F1A7AA.8080700@ti.com> <20130725223658.GJ26107@mtj.dyndns.org>
In-Reply-To: <20130725223658.GJ26107@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 July 2013 06:36 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 25, 2013 at 06:33:14PM -0400, Santosh Shilimkar wrote:
>> Any comments here. I would like to know your plan for the new
>> API. You might have seen on the ARM no-bootmem thread, we started to
>> move ARM to nobootmem with Russell's help.
> 
> Ooh, the plan sounds good to me and I was thinking you were gonna do
> it?
> 
Wooo..

Sorry if I wasn't clear before, but I need help to at least have new
memblock API support since I am not familiar with memblock code. 
I could help in adaptation to the new API for ARM arch and
core kernel code.

Let me know your thoughts.

Regards,
Santosh



