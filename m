Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3GBWgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:36:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44864 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3GBWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:36:46 -0400
Date: Tue, 2 Jul 2013 23:36:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Add support driver for Intel Rapid Start Technology
Message-ID: <20130702223644.GA13334@srcf.ucam.org>
References: <1372804061-2260-1-git-send-email-mjg59@srcf.ucam.org>
 <51D354CA.7010305@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D354CA.7010305@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 03:31:38PM -0700, Randy Dunlap wrote:

> Kconfig and Makefile changes?

Ugh. Miscommit.

> Is RST described in the current ACPI spec or somewhere else?

No, this is from staring at disassembled ACPI tables.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
