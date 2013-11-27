Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3K0AdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:33:15 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56165 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3K0AdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7U-sAu9XwV4KkXPXmFYov2FJSQ3oRrzUj=Y9XH3Ys=mA@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<1385429290-25397-9-git-send-email-yinghai@kernel.org>
	<CAErSpo5bxRJpiO8QmEQBkRGGKkTOEjnQBFRsZJG8CsaJ5JJkJg@mail.gmail.com>
	<20131126065944.GA13781@yanx>
	<CAErSpo5JVNsYxr6ka5KwLtpv7LX74SmkHsb1jED31jXfdSsxAg@mail.gmail.com>
	<CAE9FiQX0-gmijLmNLf3RWKcwDA-6a6TpPQNwj7tkRnF=990F2Q@mail.gmail.com>
	<CAErSpo7U-sAu9XwV4KkXPXmFYov2FJSQ3oRrzUj=Y9XH3Ys=mA@mail.gmail.com>
Date: Tue, 26 Nov 2013 16:33:11 -0800
X-Google-Sender-Auth: NKG8a5JRGr3ss4fwvwGRdh5o2WE
Message-ID: <CAE9FiQWtfNtGoxfii61OjtR38A9zQ5QgZmBFNaroAC5B8TWtzw@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] PCI: Try best to allocate pref mmio 64bit above 4g
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 2:01 PM, Bjorn Helgaas <bhelgaas@google.com>
>> during size bridge resource, we try to clear bridge mmio64 pref MEM_64
>> bit in bridge resource flags.
>> if one children pref mmio does not support 64bit pref mmio.
>
> A function name?  Please?

drivers/pci/setup-bus.c::pbus_size_mem()
