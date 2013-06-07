Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3FGWXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:23:47 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40173 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3FGWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <3863425.93Oeg2bhJF@vostro.rjw.lan>
References: <3863425.93Oeg2bhJF@vostro.rjw.lan>
Date: Fri, 7 Jun 2013 15:23:44 -0700
Message-ID: <CA+8MBb+NAHvTCc-NMz4+HqkDc=VUWJ8gDz7ji=HtFiDbcpWo4Q@mail.gmail.com>
Subject: Re: [GIT PULL] Power management and ACPI fixes for v3.10-rc5
From: Tony Luck <tony.luck@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 5:51 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Aaron Lu (1):
>       ACPI / scan: do not match drivers against objects having scan handlers

This patch showed up in linux-next tag next-20130605 and appears to be the
cause of a boot failure on my ia64 HP rx2600 system.  It panics with
the message:

Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or
DIG kernel

Reverting this from next-20130605 fixes my problem and I can boot again.

So please don't pull.

-Tony
