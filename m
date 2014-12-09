Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaLIVjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:39:35 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37623 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaLIVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:39:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUhwMOKEXi8mVY_rMGEAmYr13m+Gr5id+rYTC0EiwEHgw@mail.gmail.com>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
	<1418079603.13358.12.camel@kernel.crashing.org>
	<CAE9FiQUhwMOKEXi8mVY_rMGEAmYr13m+Gr5id+rYTC0EiwEHgw@mail.gmail.com>
Date: Tue, 9 Dec 2014 13:39:32 -0800
X-Google-Sender-Auth: hsZ-JIHwIuBAf9IyBCOd8Vv5zhk
Message-ID: <CAE9FiQV6s9=zK6Yx__3ZWp2SrGydb-2bnsbNDh-xD9ni0ricLQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 4:09 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Dec 8, 2014 at 3:00 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>
>>
>> I think an option would be to keep track of whether the PCI host bridge
>> can do 64-bit pref above 4G.
>
> Yes, that could be enhancement.
>
> That should fix the problem Marek's
>
> But not on Zermond's, as his system is not using _CRS.
>

http://patchwork.ozlabs.org/patch/419295/

PCI: Clear all bridge res MEM_64 if host bridge has non mem64
