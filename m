Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3KEXgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:36:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52124 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755892Ab3KEXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:35:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/3] More ACPI hotplug updates (was: [Update][PATCH 0/6] ACPI scan and hotplug fixes)
Date: Wed, 06 Nov 2013 00:32:12 +0100
Message-ID: <18462848.9zsetEL1Yy@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2970389.SeMGM45Qln@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 04, 2013 02:29:56 PM Rafael J. Wysocki wrote:
> On Monday, November 04, 2013 01:17:12 AM Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The following three patches fix some issues that we have in the common ACPI
> > hotplug infrastructure.
> > 
> > If anyone sees any problems with them, please let me know.
> 
> Well, the last patch from the last version didn't really do the right thing in
> my opinion, so new series follows.
> 
> I actually would like to squeeze it into 3.13 if there are no objections, since
> at least patch [3/6] is kind of urgent.

Three more patches for 3.13 if people don't mind, on top of the previous series
of six.  [2/3] actually is a fix, the other two are more like cleanups, but
they are worth doing at this point if no one sees any problems with them.

This is the last batch for 3.13, I promise.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
