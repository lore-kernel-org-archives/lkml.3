Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3I3C5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 22:57:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53410 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3I3C5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 22:57:51 -0400
Date: Mon, 30 Sep 2013 03:57:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
Message-ID: <20130930025733.GA21361@srcf.ucam.org>
References: <20130925001344.GA13554@redhat.com>
 <5245E7B1.2000408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245E7B1.2000408@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 03:16:49PM -0500, H. Peter Anvin wrote:
> 
> It really is starting to feel like *ALL* Dell machines need reboot=pci?

Now that ACPI is default, I'd be surprised if any of them do.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
