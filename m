Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab3CRWFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:05:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631Ab3CRWFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:05:05 -0400
Date: Mon, 18 Mar 2013 23:05:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <CAE9FiQXj0oD7_Abhz305dGytwg9_VKeEVuX128VXxEKexyvTLg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1303182304320.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan> <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz> <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz> <alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz> <CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com> <alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
 <CAE9FiQXj0oD7_Abhz305dGytwg9_VKeEVuX128VXxEKexyvTLg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Mar 2013, Yinghai Lu wrote:

> > Yes, switching from MSI to IO-APIC-fasteoi makes the report about lost
> > interrupts go away.
> >
> > My understanding from the other mail is that DAniel Vetter already has an
> > idea what might be going wrong with IRQ acking on GM45 chipsets; hopefully
> > this datapoint regarding MSI will fit into it.
> 
> What is /proc/interrupts difference between with and without pci=nomsi ?
> 
> drm is forced to share irq 16?

Yup, IRQ 16 is being shared, and one of the owners is i915.

-- 
Jiri Kosina
SUSE Labs
