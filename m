Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3EHD5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:57:47 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:33237 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3EHD5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <1367975778.25488.108.camel@pasglop>
References: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
	<1367965054-9013-4-git-send-email-yinghai@kernel.org>
	<1367965682.25488.26.camel@pasglop>
	<CAE9FiQUC74+jp0JcfpqZu=BZc+rWnnuFS5UZGKL=w_GOXeLavw@mail.gmail.com>
	<1367975778.25488.108.camel@pasglop>
Date: Tue, 7 May 2013 20:57:44 -0700
X-Google-Sender-Auth: 3WReY9kDcBMCONRildUzFEvDUYg
Message-ID: <CAE9FiQU4gqpFOLTGV8FLhdNW-EVOOtXHQqpOOY85yUemmb-3iQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] PCI: Skip IORESOURCE_MMIO allocation for root bus
 without MMIO range
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 6:16 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2013-05-07 at 15:44 -0700, Yinghai Lu wrote:
>> x86 32 socket system, we may need to leave more mmiol for only several
>> sockets to make them work with cards that does not support mmio 64 bit
>> pref.
>
> Ok, while on POWER each root bridge has its own distinct 32-bit space
> (mapped elsewhere in CPU space). So at least we don't have *that*
> specific problem :-)

Hope x86 could support that.

Yinghai
