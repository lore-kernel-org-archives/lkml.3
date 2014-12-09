Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaLITth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:49:37 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45565 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaLITtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:49:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141209075619.GA23327@richard>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
	<CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
	<20141209001119.GA24661@shangw>
	<20141209022601.GA16207@richard>
	<CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>
	<20141209075619.GA23327@richard>
Date: Tue, 9 Dec 2014 11:49:34 -0800
X-Google-Sender-Auth: 2zs79pmYbIkysIWyMTde-hmUuu4
Message-ID: <CAE9FiQWrMs4b5HmbiJTmq=3g_Pv1_Zp1c5=P=uXTgLD6Txs-Bw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 11:56 PM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:

> Two comments to this patch:
> 1. realloc_head is not necessary here

why ?

want to align that with pbus_size_mem.

> 2. In case we have two MEM BAR under a bus, one is MEM64|PREF and one is PREF,
> after this patch, the MEM64 flag will be cleared, right? If so, this may fall
> back to the same situation in bug 74151.

Yes.

Thanks

Yinghai
