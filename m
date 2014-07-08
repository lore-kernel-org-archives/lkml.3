Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaGHDrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:47:18 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59602 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaGHDrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:47:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140705173200.GA26618@google.com>
References: <1403719007-9352-1-git-send-email-kishon@ti.com>
	<20140705173200.GA26618@google.com>
Date: Tue, 8 Jul 2014 09:17:15 +0530
Message-ID: <CAHM4w1nxKyDWdNhqLVaQs0ptRU4QfFCPai1bnOiX6SxiZNcX5Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] dra7: Add PCIe support
From: Pratyush Anand <pratyush.anand@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Mohit KUMAR DCG <mohit.kumar@st.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2014 at 11:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Jun 25, 2014 at 11:26:44PM +0530, Kishon Vijay Abraham I wrote:
>> [1] is split into separate series in order for individual subsystem
>> Maintainers to pick up the patches. This series handles the PCIe
>> support for DRA7.
>>
>> Rebased to 3.16-rc2.
>>
>> [1] -> https://lkml.org/lkml/2014/5/29/258
>>
>> Kishon Vijay Abraham I (3):
>>   PCI: designware: Configuration space should be specified in 'reg'
>>   PCI: designware: use untranslated address while programming ATU
>>   PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller
>
> Mohit, I see your ack for [1/3], but not for [2/3]; are you OK with that,
> too?
>
> Pratyush, you had some questions about [2/3]; are you happy with that one?

OK for me.

~Pratyush
