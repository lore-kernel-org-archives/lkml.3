Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbbA2Of7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:35:59 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33250 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbbA2Of4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <m37fw6xga8.fsf@t19.piap.pl>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
 <1420857290-8373-7-git-send-email-robh@kernel.org> <m37fw6xga8.fsf@t19.piap.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Jan 2015 08:35:35 -0600
Message-ID: <CAErSpo56H5uUz4zOLk6j5m0Of8ZrZdc_bmNkHuGhEfx2WJvqeQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] ARM: cns3xxx: convert PCI to use generic config accesses
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 12:16 AM, Krzysztof Hałasa <khalasa@piap.pl> wrote:
> Rob Herring <robh@kernel.org> writes:
>
>> Convert the cns3xxx PCI driver to use the generic config access functions.
>>
>> This changes accesses from __raw_readl/__raw_writel to readl/writel.
>>
>>  arch/arm/mach-cns3xxx/pcie.c | 52 +++++++++-----------------------------------
>
> This looks fine:
> Acked-by: Krzysztof Hałasa <khalasa@piap.pl>

Thanks, I added your ack.
