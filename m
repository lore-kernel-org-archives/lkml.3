Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaLITmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:42:53 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37468 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLITmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:42:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7OXLco+fagqpK00Cc_AGxjEDJO5JDBtr_p92L2tpvs+Q@mail.gmail.com>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
	<CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
	<20141209001119.GA24661@shangw>
	<20141209022601.GA16207@richard>
	<CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>
	<54873A45.3050009@gmail.com>
	<CAErSpo7OXLco+fagqpK00Cc_AGxjEDJO5JDBtr_p92L2tpvs+Q@mail.gmail.com>
Date: Tue, 9 Dec 2014 11:42:50 -0800
X-Google-Sender-Auth: qWpSzdyEbDREJVmrLLDDgTNAQww
Message-ID: <CAE9FiQWPGLwQsz5HtW7r0Lrk4DMqfhbmk=ohcBWtWqXAN3mEZw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 10:22 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Dec 9, 2014 at 11:07 AM, Marek Kordík <kordikmarek@gmail.com> wrote:
>> I have built and booted your branch and it works well. Do you want me to
>> attach some logs?
>> (I am new here and I have read http://www.tux.org/lkml/ and I don't want to
>> break some rules for attachment size)

Hi Marek,

Can you run some graphics benchmark program to check the performance
between
1.

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
 branch: for-pci-allocate-fit-3.18

2.
v 3.18 + clear mmio64 flags when children device does not support it

Thanks

Yinghai
