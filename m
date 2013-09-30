Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3I3Ec1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 00:32:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53925 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3I3EcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 00:32:25 -0400
Date: Mon, 30 Sep 2013 05:32:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
Message-ID: <20130930043213.GA22194@srcf.ucam.org>
References: <20130925001344.GA13554@redhat.com>
 <5245E7B1.2000408@zytor.com>
 <20130930025733.GA21361@srcf.ucam.org>
 <5248E8C2.2000108@zytor.com>
 <20130930030655.GB21361@srcf.ucam.org>
 <CAPM=9txNWRKPzE=FNz63fi-7mwQq5DvNkVHik4gNodD9WBP9mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txNWRKPzE=FNz63fi-7mwQq5DvNkVHik4gNodD9WBP9mw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 01:15:02PM +1000, Dave Airlie wrote:
> On Mon, Sep 30, 2013 at 1:06 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Likely indicates that our ACPI reboot handling still isn't bug
> > compatible with Windows. We'd do better fixing that than adding more DMI
> > entries.
> 
> are these only with VTd enabled? I have some Dells that won't reboot
> with VTd turned on, I remember you though it was an acpi bug we
> couldn't do much with.

Oh, that's true - the ACPI reboot vector on the Dell tables I have to 
hand appears to be via the keyboard controller, so there's probably some 
SMM involved. I don't know if the VTd thing is still a problem (David 
Woodhouse was looking into that at one point), but that would be a 
reasonable point to start from.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
