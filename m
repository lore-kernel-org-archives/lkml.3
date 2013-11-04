Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3KDN0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:26:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65159 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753373Ab3KDN0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:26:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [Update][PATCH 0/6] ACPI scan and hotplug fixes
Date: Mon, 04 Nov 2013 14:29:56 +0100
Message-ID: <2970389.SeMGM45Qln@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5839747.7HXXGHmMBd@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 04, 2013 01:17:12 AM Rafael J. Wysocki wrote:
> Hi,
> 
> The following three patches fix some issues that we have in the common ACPI
> hotplug infrastructure.
> 
> If anyone sees any problems with them, please let me know.

Well, the last patch from the last version didn't really do the right thing in
my opinion, so new series follows.

I actually would like to squeeze it into 3.13 if there are no objections, since
at least patch [3/6] is kind of urgent.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
