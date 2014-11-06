Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKFAGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:06:47 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:51089 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaKFAGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:06:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Thu, 06 Nov 2014 01:06:39 +0100
Message-ID: <2679650.sLyVOFDaTG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141105234058.GK6168@google.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <2355100.WsW1DXh57P@wuerfel> <20141105234058.GK6168@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bUN+rzWqWOiVxIVlA5UMEnv7xJ9d3p/Y4w7gO5vZYMD
 KuEOw945rOMzAYKO/sUcAKMQUFJFboXwB2yLe6KNj0PvbH/Vtg
 45AshUASXlEUgSdue0YP74nVySrf7Jkr7Cere0Wku3pAv0m0Mt
 6k3FgFEb9jJH8jqf9MEbdG2NhrDtH2S1+zhnZgVWi9FhHMG5N/
 poMfoJDQdKme48GT5+0cLYfoA6l8VQmT/S+YsZpXlt2aFA4sXm
 RQFUj7qpLef9leumghHztUxoTJfkknIHdm/Lcy19CqHiytsN5M
 qrdpmu0eFENArdMic7M/cATnNvEBm1VamegWfA/ff/GJhGmgNj
 1q5DRNUZTkRrv9zTXjYk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 November 2014 16:40:58 Bjorn Helgaas wrote:
> > 
> > See below for a sample patch I just did. It duplicates the code from
> > pci_common_init_dev/pci_common_init because we know that all users
> > of pci_common_init_dev are modern and only pass a single host bridge.
> > The new pci_common_init_dev is simpler than the old one but should
> > do the exact same thing for all current users, with the addition
> > of propagating the return value.
> 
> Same with this one; I'm ignoring for now on the theory that this was just a
> sample to show the idea, and a more formal patch might come later.
> 

Correct. Or we might not do it at all, if some of the other patches
are done before we need this.

	Arnd
