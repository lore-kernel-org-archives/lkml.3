Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaLRN2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 08:28:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58511 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaLRN2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:28:06 -0500
Date: Thu, 18 Dec 2014 13:27:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Dmitry Tunin <hanipouspilot@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
Message-ID: <20141218132753.GA4918@srcf.ucam.org>
References: <5492C5A3.8090700@gmail.com>
 <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 08:25:42AM -0500, Josh Boyer wrote:

> What does this do to the rest of the function keys?  Does everything
> else still work as expected, including suspend and resume?

Disabling OSI completely certainly runs the risk of turning off things 
like HPET. It certainly shouldn't be done without checking the ACPI 
tables, and it really shouldn't be done at all because this is Intel's 
bug and they should just fix it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
