Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062Ab3BTMuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:50:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40247 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab3BTMum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:50:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: manual merge of the pm tree with the pci tree
Date: Wed, 20 Feb 2013 13:57:18 +0100
Message-ID: <1599012.kNnWTW8njt@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130220125555.46e16e16836ba48f70beb3a9@canb.auug.org.au>
References: <20130220125555.46e16e16836ba48f70beb3a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, February 20, 2013 12:55:55 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> drivers/pci/pci-acpi.c between commit 181380b702ee ("PCI/ACPI: Don't
> cache _PRT, and don't associate them with bus numbers") from the pci tree
> and commit bc9b6407bd6d ("ACPI / PM: Rework the handling of devices
> depending on power resources") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for the notice and fix.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
