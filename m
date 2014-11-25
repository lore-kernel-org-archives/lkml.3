Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaKYRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:25:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52138 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:25:55 -0500
Date: Tue, 25 Nov 2014 17:25:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] radeon: acquire BIOS via firmware subsystem if
 everything else failed
Message-ID: <20141125172550.GA19688@srcf.ucam.org>
References: <20141122193025.GA5782@kaos.lebenslange-mailadresse.de>
 <CADnq5_OCeJ2M6qJXLXVow-RN6nZjBjmhQwu-FLSjLwwLWpsE5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_OCeJ2M6qJXLXVow-RN6nZjBjmhQwu-FLSjLwwLWpsE5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:14:21PM -0500, Alex Deucher wrote:
> The vbios image is available via ACPI prior to the OS taking over.
> IIRC, Matthew Garret fixed up the bootloader to fetch the vbios image
> prior to loading Linux so that it could be accessed after the OS
> loaded.

EFI rather than ACPI, but yeah. In theory this should work fine if 
you're using the EFI entry point. I don't know whether the patches for 
linuxefi were ever accepted by grub upstream - if not, pushing those 
would make more sense.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
