Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaEAP5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:57:35 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60947 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaEAP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <5362505E.8010106@infradead.org>
References: <20140430194229.8155.98965.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <5362505E.8010106@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 1 May 2014 09:57:11 -0600
Message-ID: <CAErSpo5sZLy66suDg5azdAHxxNE=qCVAXQ9OVS-A8u1CpAq1Ew@mail.gmail.com>
Subject: Re: [PATCH] DMA-API: Clarify physical/bus address distinction
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 7:47 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/30/2014 12:42 PM, Bjorn Helgaas wrote:
>>
>> The DMA-API documentation sometimes refers to "physical addresses" when it
>> really means "bus addresses."  Historically these were often the same, but
>> they may be different if the bridge leading to the bus performs address
>> transaction.  Update the documentation to use "bus address" when
>
>
>   translation.

Fixed, thanks!
