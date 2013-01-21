Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3AUU4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:56:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33572 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AUU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:56:18 -0500
Date: Mon, 21 Jan 2013 20:56:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Tim Gardner <rtg.canonical@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org,
        "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI
 facilities
Message-ID: <20130121205611.GA15093@srcf.ucam.org>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
 <1358800838-10459-2-git-send-email-matt@console-pimps.org>
 <50FDAB06.8040701@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FDAB06.8040701@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:54:30PM -0700, Dave Jiang wrote:

> I think that here we may need to be checking efi_enabled(EFI_BOOT)
> instead. We are interested in the kernel was booted from EFI and
> that EFI variables support is present. Or is getting efi variable
> part of runtime services?

GetVariable is part of runtime services, yes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
