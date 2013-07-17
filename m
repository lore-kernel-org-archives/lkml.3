Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3GQCV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:21:29 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:37630 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3GQCV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:21:27 -0400
MIME-Version: 1.0
Date: Tue, 16 Jul 2013 20:21:26 -0600
Message-ID: <CAL-B5D03ki8NHsM6EuESTH2K-Eh+XyFHNXPDYwgDq+oagDjtMQ@mail.gmail.com>
Subject: Linux Plumbers ACPI/PM, PCI Microconference
From: Myron Stowe <myron.stowe@gmail.com>
To: linux-pci <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Plumbers has approved an ACPI/PM, PCI microconference. The
overview page is here:

http://wiki.linuxplumbersconf.org/2013:pci_subsystem

We would like to start receiving volunteers for presenting topics of
interest.  There is a lot of activity in these subsystems so please
respond by submitting presentation or discussion proposals that you
would be willing to cover for consideration.  You should also feel
free to submit ideas as proposals that others could cover.  The
instructions for submitting ideas should be at:

http://www.linuxplumbersconf.org/2013/submitting-topic/

This is the "Plumbers" conference so topics concerning userspace
interaction with the kernel and not just topics concerning pure kernel
subsystem internals would be greatly welcomed.  As a possible aid
towards promoting topics for submissions we have listed a few
candidates that seem to meet the criteria in the microconference
proposals wiki located at
http://wiki.linuxplumbersconf.org/2013:pci_subsystem

Last year, we had a good discussion on general issues in PCI space -
that also might be worth giving updates on.

If you have topics that you would like to add, wait until the
instructions get posted at the link above. If you are impatient, feel
free to email me directly (but probably best to drop the broad mailing
lists from the reply).

Thanks!

Len, Bjorn, Myron, Rafael



Yinghai - An update on host bridge hot-add capabilities, what is in
place and what still remains to be done, would seem like a good topic.

Shuah - You brought up the idea about "Converting drivers from Legacy
PM ops to dev_pm_ops"; would you like to present what you have
done/encountered so far?
