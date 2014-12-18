Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaLROnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:43:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:59541 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaLROnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:43:43 -0500
Date: Thu, 18 Dec 2014 14:43:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Tunin <hanipouspilot@gmail.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v3 1/2] acpi: Add "acpi_osi=" for ASUS X200MA to enable,
 brightness keys
Message-ID: <20141218144337.GA7613@srcf.ucam.org>
References: <CA+5PVA43jLUp4K9=56nwgQJEyLB9EkEynb2PqfEhBWD8q-m-DQ@mail.gmail.com>
 <5492D938.1020907@gmail.com>
 <20141218135705.GD4918@srcf.ucam.org>
 <5492DEE7.8010407@gmail.com>
 <20141218140930.GA6436@srcf.ucam.org>
 <5492E32E.2030602@gmail.com>
 <20141218142629.GA6924@srcf.ucam.org>
 <5492E5F9.2000504@gmail.com>
 <20141218143623.GA7335@srcf.ucam.org>
 <5492E753.7090505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5492E753.7090505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual fix is known - Intel need to fix their code to match their 
specification. Applying this patch may break functionality that other 
users are depending on.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
