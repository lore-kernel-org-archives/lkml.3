Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaJVQti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:49:38 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:40799 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaJVQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2430078.s4snyh5OoF@wuerfel> <20141001084626.GZ841@e106497-lin.cambridge.arm.com>
 <3256560.C0cZnIlnAv@wuerfel> <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 22 Oct 2014 10:49:14 -0600
Message-ID: <CAErSpo4DPU6_TO9atpzDbu-X9iddrnBk3QQV4_BcpUCFL4JUdw@mail.gmail.com>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 9:59 AM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:

> ... I wonder what's the
> best course of action. Putting together all the bits and pieces required
> to remove PCI bios dependency from this patch can take a while, I wonder
> whether we should aim for merging this driver (rebased on top of my port to the
> new parse ranges API) with the ARM/ARM64 ifdeffery and clean it up later
> or aim for the whole thing at once, I am just worried it can take us a while.

I haven't looked at your patches, but "the whole thing at once" is
never *my* goal.  A gradual cleanup is just fine with me.

Bjorn
