Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaLIWPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:15:54 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43087 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaLIWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:15:53 -0500
Message-ID: <54877495.9090102@gmail.com>
Date: Tue, 09 Dec 2014 23:15:49 +0100
From: =?UTF-8?B?TWFyZWsgS29yZMOtaw==?= <kordikmarek@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Wei Yang <weiyang@linux.vnet.ibm.com>, Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not support
 it
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>	<1418079372.13358.9.camel@kernel.crashing.org>	<CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>	<20141209001119.GA24661@shangw>	<20141209022601.GA16207@richard>	<CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>	<54873A45.3050009@gmail.com>	<CAErSpo7OXLco+fagqpK00Cc_AGxjEDJO5JDBtr_p92L2tpvs+Q@mail.gmail.com> <CAE9FiQWPGLwQsz5HtW7r0Lrk4DMqfhbmk=ohcBWtWqXAN3mEZw@mail.gmail.com>
In-Reply-To: <CAE9FiQWPGLwQsz5HtW7r0Lrk4DMqfhbmk=ohcBWtWqXAN3mEZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:42 PM, Yinghai Lu wrote:
> On Tue, Dec 9, 2014 at 10:22 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Dec 9, 2014 at 11:07 AM, Marek Kordík <kordikmarek@gmail.com> wrote:
>>> I have built and booted your branch and it works well. Do you want me to
>>> attach some logs?
>>> (I am new here and I have read http://www.tux.org/lkml/ and I don't want to
>>> break some rules for attachment size)
>
> Hi Marek,
>
> Can you run some graphics benchmark program to check the performance
> between
> 1.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>   branch: for-pci-allocate-fit-3.18
>
> 2.
> v 3.18 + clear mmio64 flags when children device does not support it
>
> Thanks
>
> Yinghai
>
I have run Unigine Heaven benchmark on both versions (I tried version 2. 
with and also without kernel parameters "debug ignore_loglevel 
pci=realloc") and the performance of each version was the same (70-71 
points). I tried to run this benchmark also with kernel 3.15.10 and the 
result was 67 points. Tomorrow I can try to run some more benchmarks, 
today I didn't have much time.

Marek
