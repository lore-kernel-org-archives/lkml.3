Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3AUAsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:48:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47931 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab3AUAsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:48:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC][Update][PATCH 0/3] ACPI / PM: Export power resources information to user space
Date: Mon, 21 Jan 2013 01:48:55 +0100
Message-ID: <2096792.ELJ8WGVaaz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3307415.pdOY6ovZLa@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 20, 2013 03:51:40 PM Rafael J. Wysocki wrote:
> Hi Greg,
> 
> The following patch series is about exporting ACPI power resources to user
> space that will be necessary for PM diagnostics on new platforms (powertop is
> the target).  Still, existing systems can also benefit from that, like my
> oldish HP nx6325 on which the patches have been tested.
> 
> Patch [1/3] shouldn't be really controverisal, as it only makes it possible
> to read power resources' reference counters from user space in a quite
> straightforward way.
> 
> Patch [3/3], however, exposes lists of power resources associated with
> different power states of devices using ACPI PM as sysfs subdirectories
> containing symbolic links and that requires some sysfs changes made by
> patch [2/3].
> 
> Admittedly, my sysfs skills are limited so please let me know if those
> changes make sense and are acceptable from your perspective.  If not, then
> please kindly advise what I can do instead of them.
> 
> The patches apply on top of the current linux-next branch of the linux-pm.git
> tree.

Refreshed with Documentation/ABI files as requested.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
