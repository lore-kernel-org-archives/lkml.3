Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaANQGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:06:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59914 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:06:09 -0500
Date: Tue, 14 Jan 2014 16:06:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, l@dorileo.org, "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Message-ID: <20140114160601.GB4307@srcf.ucam.org>
References: <1389019837-13619-1-git-send-email-tianyu.lan@intel.com>
 <20140106175912.GA2754@core.coreip.homeip.net>
 <1793775.ULjNzyMivD@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1793775.ULjNzyMivD@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 11:25:53PM +0100, Rafael J. Wysocki wrote:

> Queued up as a fix for 3.13 (I fixed up the indentation).

Ah, sorry, I missed this chunk of the thread. If the system provides 
valid _BIF data then we should possibly just fall back to that rather 
than adding another quirk table.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
