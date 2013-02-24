Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3BXOQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 09:16:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42966 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab3BXOQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 09:16:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] PCI changes for v3.9
Date: Sun, 24 Feb 2013 15:23:18 +0100
Message-ID: <8468951.JBoAbzYJmH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
References: <20130223212120.GA4593@google.com> <CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 06:49:27 PM Yinghai Lu wrote:
> On Sat, Feb 23, 2013 at 1:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
> >
> >   Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.9-changes
> >
> > for you to fetch changes up to 018ba0a6efada61b9bc17500101d81c3d35807c2:
> >
> >   Merge branch 'pci/yinghai-root-bus-hotplug' into next (2013-02-19 11:42:17 -0700)
> 
> may render of bunch of conflicts...
> 
> Please check if attached diff is right, and hope it could save Linus some time.

It looks correct to me as far as the ACPI part is concerned.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
