Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaIXNnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:43:24 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52915 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaIXNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:43:22 -0400
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Adding iommu/fixing DRHD without BIOS intervention?
From: Peter Kay <syllopsium@syllopsium.co.uk>
Date: Wed, 24 Sep 2014 14:43:03 +0100
To: linux-kernel@vger.kernel.org
Message-ID: <29c00762-1827-4276-a386-89f9c2c53529@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an issue with an X38 based motherboard BIOS where the DRHD cap/ecap returns all ones. The RMRR appears to be present as do other structures. There will not be BIOS updates available.

I've searched the mailing list for the last four years and found this vaguely covered before but with no low level info. Is it possible to manually set up an IOMMU without BIOS intervention, and if so where is the documentation? I've read (parts of) the VT-d spec and the X38 Express chipset datasheet but it appears to lack how the IOMMU is initially set up.

Is this an NDA Intel only document (I note AMD's docs have a bit more information on which things to poke), or is there something publicly available/I've not understood the docs?

Thanks for any info, even if the answer is 'this is NDA and always will be'. Asking here because I can't find anywhere better (tried BIOS vendor and Intel virtualisation forum) and I've been using KVM/Xen with a Linux dom0.

Please CC on replies; I am not subscribed to the list.

PK
