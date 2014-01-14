Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaANQFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:05:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59873 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaANQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:05:01 -0500
Date: Tue, 14 Jan 2014 16:04:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, fcr@adinet.com.uy,
        "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Message-ID: <20140114160444.GA4307@srcf.ucam.org>
References: <1388648277-23453-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388648277-23453-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 03:37:57PM +0800, Lan Tianyu wrote:
> The aml method _BIX of NEC LZ750/LS returns a broken package which
> skip the first member "Revision" according ACPI 5.0 spec Table 10-234.

Why don't we just ignore an invalid _BIX and fall back to _BIF? That 
seems more reasonable than setting a precedent for fixing up invalid 
data.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
