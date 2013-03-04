Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab3CDP4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:56:38 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51952 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3CDP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:56:36 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI / ACPI: Rework ACPI device nodes lookup for the PCI bus type
Date: Mon, 04 Mar 2013 16:56:32 +0100
Message-ID: <3708737.8uVhOFRC2j@al>
User-Agent: KMail/4.10 (Linux/3.8.0-2-custom; KDE/4.10.0; x86_64; ; )
In-Reply-To: <3268331.1fmya6KvOh@vostro.rjw.lan>
References: <16168955.038G1kVfN2@vostro.rjw.lan> <4892526.yENRuuZvDT@al> <3268331.1fmya6KvOh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2013 20:12:59 Rafael J. Wysocki wrote:
> On Wednesday, January 23, 2013 08:00:31 PM Peter Wu wrote:
> > Hi,
> > 
> > Any progress on this one? I guess it won't make into 3.8, perhaps 3.9?
> 
> No, that doesn't go anywhere for now.
> 
> In fact, I need to discuss that with Len.
Is this patch still valid? If not, what patch do you suggest for users of the 
affected Lenovo machines? (please CC me in a related discussion)

Regards,
Peter
