Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3BZFTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:19:54 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49278 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3BZFTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
References: <20130223212120.GA4593@google.com>
	<CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
Date: Mon, 25 Feb 2013 21:19:50 -0800
X-Google-Sender-Auth: ituMyDyNBoL6MYoJ3Q9oRJ_zMzU
Message-ID: <CA+55aFx7jq7ruTN+pnp-4hPHnkr1G-1WAiAJSQYTPr7GOJjExw@mail.gmail.com>
Subject: Re: [GIT PULL] PCI changes for v3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Please check if attached diff is right, and hope it could save Linus some time.

Hmm. I did things a bit differently, moving things around more in
drivers/acpi/internal.h.

Also, my *gut* feel is that the new _handle_hotplug_event_root()
function should do that whole dance with
acpi_scan_lock_acquire()/acpi_scan_lock_release(), but I didn't really
know if it's required or appropriate, so I left it alone. Could you
take a look?

            Linus
