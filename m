Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3AUAFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:05:32 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47885 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3AUAFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:05:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 0/3] ACPI / PM: Export power resources information to user space
Date: Mon, 21 Jan 2013 01:11:29 +0100
Message-ID: <1675261.H9ZPINxtqq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130120233735.GA7449@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <20130120233735.GA7449@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 20, 2013 03:37:35 PM Greg Kroah-Hartman wrote:
> On Sun, Jan 20, 2013 at 03:51:40PM +0100, Rafael J. Wysocki wrote:
> > Hi Greg,
> > 
> > The following patch series is about exporting ACPI power resources to user
> > space that will be necessary for PM diagnostics on new platforms (powertop is
> > the target).  Still, existing systems can also benefit from that, like my
> > oldish HP nx6325 on which the patches have been tested.
> > 
> > Patch [1/3] shouldn't be really controverisal, as it only makes it possible
> > to read power resources' reference counters from user space in a quite
> > straightforward way.
> 
> You need to add a Documentation/ABI/ entry for the new file you created
> here.  Same thing for 3/3, which will help me understand exactly what
> you are trying to do here with sysfs.  Care to update that so I can try
> to figure out if the sysfs code is correct?

I will.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
