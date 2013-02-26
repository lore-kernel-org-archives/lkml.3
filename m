Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3BZR1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:27:41 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:8449 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3BZR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:27:39 -0500
Message-ID: <1361899004.12845.96.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] ACPI: Add sysfs links from memory device to memblocks
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vasilis.liaskovitis@profitbricks.com" 
	<vasilis.liaskovitis@profitbricks.com>
Date: Tue, 26 Feb 2013 10:16:44 -0700
In-Reply-To: <512C4A07.40903@jp.fujitsu.com>
References: <1361826130-31062-1-git-send-email-toshi.kani@hp.com>
	 <512C4A07.40903@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 05:37 +0000, Yasuaki Ishimatsu wrote:
> 2013/02/26 6:02, Toshi Kani wrote:
> > In order to eject a memory device object represented as "PNP0C80:%d"
> > in sysfs, its associated memblocks (system/memory/memory%d) need to
> > be off-lined.  However, there is no user friendly way to correlate
> > between a memory device object and its memblocks in sysfs.
> > 
> > This patch creates sysfs links to memblocks under a memory device
> > object so that a user can easily checks and manipulates its memblocks
> > in sysfs.
> > 
> > For example, when PNP0C80:05 is associated with memory8 and memory9,
> > the following two links are created under PNP0C80:05.  This allows
> > a user to access memory8/9 directly from PNP0C80:05.
> > 
> >    # ll /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C80:05
> >    lrwxrwxrwx. memory8 -> ../../../system/memory/memory8
> >    lrwxrwxrwx. memory9 -> ../../../system/memory/memory9
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> 
> I confirmed that the patch has no problem.
> Feel free to add:
> 
> Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Great!  Thanks Yasuaki!
-Toshi


