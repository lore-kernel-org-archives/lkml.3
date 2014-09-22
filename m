Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaIVWNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:13:16 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:45339 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaIVWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <541E11BB.7070202@gmail.com>
References: <1411236391-422-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1411236391-422-4-git-send-email-sebastian.hesselbarth@gmail.com> <541E11BB.7070202@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 22 Sep 2014 16:12:54 -0600
Message-ID: <CAErSpo7EX-jndHSvzjmpHs+hNiBieMGX58tCz2C8Ce9WJjQ_ZQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: mvebu: armada-xp: Correct misnumbered PCIe port nodes
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 5:46 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 09/20/2014 08:06 PM, Sebastian Hesselbarth wrote:
>> Currently, Armada XP PCIe nodes are numbered pcie@<N>,0 with N just
>> incrementing. To reflect port/lane relationship, rename the nodes
>> to pcie@<port>,<lane>. While at it, add node aliases to each of pcie
>> controller and port nodes and get rid of now redundant port/lane
>> comments.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>
> After thinking a while about the current numbering scheme, I have to
> admit that it is correct. The @numbers represent assigned-address of
> the pcie port and this what it is right now.
>
> If there are no more comments, I'll resend the series without messing
> with the numbering scheme.

If your intention is that these go through my PCI tree, please cc:
linux-pci@vger.kernel.org, because I only look at the linux-pci
patchwork for things to merge.

Bjorn
