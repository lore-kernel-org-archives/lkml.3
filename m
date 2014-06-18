Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaFRXZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:25:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64513 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754167AbaFRXZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:25:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH 1/4] ACPI: Support _OSI("Darwin") correctly
Date: Thu, 19 Jun 2014 01:42:56 +0200
Message-ID: <3186737.5xBXzTniGn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140618052615.GA26873@srcf.ucam.org>
References: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com> <20140617144614.GA16934@srcf.ucam.org> <20140618052615.GA26873@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 06:26:15 AM Matthew Garrett wrote:
> On Tue, Jun 17, 2014 at 03:46:15PM +0100, Matthew Garrett wrote:
> > On Tue, Jun 17, 2014 at 02:11:36PM +0200, Rafael J. Wysocki wrote:
> > > Does applying this patch without the rest of the series makes things worse
> > > or better on the machines in question (or perhaps it doesn't matter at all
> > > alone)?
> > 
> > On its own, I think this will do nothing.
> 
> Ugh, no, sorry - on its own, this will break PCIe hotplug events and 
> battery reporting. It should only be merged with the others.

Well, in that case it is not useful to split that material into
multiple patches.  And it will need to be Linux-specific, as adding
patch [1/4] to upstream ACPICA might break some other OSes using it.

Rafael

