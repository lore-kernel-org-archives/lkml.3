Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaCFUZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:25:36 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:57598 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbaCFUZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:25:34 -0500
Message-ID: <1394137532.2682.5.camel@x41>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Date: Thu, 06 Mar 2014 21:25:32 +0100
In-Reply-To: <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
	 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2014 20:25:33.0431 (UTC) FILETIME=[39B9E070:01CF397A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas schreef op ma 10-02-2014 om 14:33 [-0700]:
> Can you open a kernel.org bugzilla report and attach complete dmesg
> logs of the working and broken kernels to it?  There might be more
> useful resource-related messages from the PCI core.

That took me quite a bit longer than I hoped, but I finally opened a
report at
https://bugzilla.kernel.org/show_bug.cgi?id=71611 .

Note that the dmesg's are identical (up to that error). Are you still
interested?

> I wouldn't start bisecting yet, but if you're in the mood, this
> commit: 96702be56037 "Merge branch 'pci/resource' into next" looks
> like a good place to start, so you could try the pre-merge commit:
> 04f982beb900 "Merge branch 'pci/msi' into next".  If 04f982beb900 is
> good, there are only about 15 commits on the pci/resource branch to
> look at.

I hope to do a bisect in the next few days. If that bisect pinpoints an
interesting commit that might just be in time for v3.14.


Paul Bolle

