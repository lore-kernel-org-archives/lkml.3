Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaANQII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:08:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59981 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaANQIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:08:05 -0500
Date: Tue, 14 Jan 2014 16:07:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Feng Kan <fkan@apm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V2 0/6] Enable X-Gene platform reboot driver.
Message-ID: <20140114160755.GC4307@srcf.ucam.org>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389135041-16062-1-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:50:35PM -0800, Feng Kan wrote:
> Enable X-Gene platform driver for the X-Gene platform. Remove the
> use of the mask attribute from the reboot dts node. Add support
> for using the ACPI and DTS resource for the reboot driver.

Why can't you just use the standard ACPI reboot register values in the 
FADT?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
