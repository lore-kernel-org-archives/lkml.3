Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3KZBEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:04:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35044 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3KZBEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:04:04 -0500
Date: Tue, 26 Nov 2013 01:03:48 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Paul Drews <paul.drews@intel.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linus.walleij@linaro.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Add BayTrail SoC GPIO and LPSS ACPI IDs
Message-ID: <20131126010348.GA29198@srcf.ucam.org>
References: <1385417755-21776-1-git-send-email-paul.drews@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385417755-21776-1-git-send-email-paul.drews@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 02:15:55PM -0800, Paul Drews wrote:
> This adds the new ACPI ID (INT33FC) for the BayTrail GPIO
> banks as seen on a BayTrail M System-On-Chip platform.  This
> ACPI ID is used by the BayTrail GPIO (pinctrl) driver to
> manage the Low Power Subsystem (LPSS).

Not that we can do anything about this now, but if they have the same 
programming model why isn't there a CID that covers them?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
