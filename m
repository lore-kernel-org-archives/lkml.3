Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaCGJsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:48:23 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52428 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbaCGJsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:48:20 -0500
Message-ID: <1394185698.5608.5.camel@x41>
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
Date: Fri, 07 Mar 2014 10:48:18 +0100
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
X-OriginalArrivalTime: 07 Mar 2014 09:48:19.0517 (UTC) FILETIME=[5EF356D0:01CF39EA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas schreef op ma 10-02-2014 om 14:33 [-0700]:
> I wouldn't start bisecting yet, but if you're in the mood, this
> commit: 96702be56037 "Merge branch 'pci/resource' into next" looks
> like a good place to start, so you could try the pre-merge commit:
> 04f982beb900 "Merge branch 'pci/msi' into next".  If 04f982beb900 is
> good, there are only about 15 commits on the pci/resource branch to
> look at.

This might end up not being relevant. And this is surely documented
somewhere, but anyhow:
- what git magic returns the hashes of the 15 commits that merge commit
  96702be56037 added to the tree; and
- how can I use the list of those hashes to limit the range of commits
  to do a git bisect?


Paul Bolle

