Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3EHBQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 21:16:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:51229 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab3EHBQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 21:16:32 -0400
Message-ID: <1367975778.25488.108.camel@pasglop>
Subject: Re: [PATCH v3 3/5] PCI: Skip IORESOURCE_MMIO allocation for root
 bus without MMIO range
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 08 May 2013 11:16:18 +1000
In-Reply-To: <CAE9FiQUC74+jp0JcfpqZu=BZc+rWnnuFS5UZGKL=w_GOXeLavw@mail.gmail.com>
References: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
	 <1367965054-9013-4-git-send-email-yinghai@kernel.org>
	 <1367965682.25488.26.camel@pasglop>
	 <CAE9FiQUC74+jp0JcfpqZu=BZc+rWnnuFS5UZGKL=w_GOXeLavw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 15:44 -0700, Yinghai Lu wrote:
> x86 32 socket system, we may need to leave more mmiol for only several
> sockets to make them work with cards that does not support mmio 64 bit
> pref.

Ok, while on POWER each root bridge has its own distinct 32-bit space
(mapped elsewhere in CPU space). So at least we don't have *that*
specific problem :-)

Cheers,
Ben.


