Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3I3DHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 23:07:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53464 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3I3DHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 23:07:02 -0400
Date: Mon, 30 Sep 2013 04:06:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
Message-ID: <20130930030655.GB21361@srcf.ucam.org>
References: <20130925001344.GA13554@redhat.com>
 <5245E7B1.2000408@zytor.com>
 <20130930025733.GA21361@srcf.ucam.org>
 <5248E8C2.2000108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248E8C2.2000108@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 07:58:10PM -0700, H. Peter Anvin wrote:
> On 09/29/2013 07:57 PM, Matthew Garrett wrote:
> > On Fri, Sep 27, 2013 at 03:16:49PM -0500, H. Peter Anvin wrote:
> >>
> >> It really is starting to feel like *ALL* Dell machines need reboot=pci?
> > 
> > Now that ACPI is default, I'd be surprised if any of them do.
> > 
> 
> Look at the stream of Dell machines we're still getting reboot bug
> reports for...

Likely indicates that our ACPI reboot handling still isn't bug 
compatible with Windows. We'd do better fixing that than adding more DMI 
entries.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
