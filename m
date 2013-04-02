Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557Ab3DBQEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:04:05 -0400
Received: from 8bytes.org ([85.214.48.195]:54001 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761529Ab3DBQEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:04:04 -0400
Date: Tue, 2 Apr 2013 18:04:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>, suravee.suthikulpanit@amd.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402160400.GP30540@8bytes.org>
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
 <20130402150302.GF15687@8bytes.org>
 <20130402152956.GE4391@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402152956.GE4391@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 18:04:01 2013
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515b017123678656392098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 05:29:56PM +0200, Borislav Petkov wrote:
> On Tue, Apr 02, 2013 at 05:03:04PM +0200, Joerg Roedel wrote:

> Good luck trying to get ASUS to fix anything in their BIOS :(.

Hmm...

> Can't we detect the SB IOAPIC some other way in this case?

I can certainly write a patch that works around your particular BIOS
bug. The problem is that such a fix will most certainly break other
systems.

Unfortunatly there is no reliable way to fixup the IO-APIC-ID->DEVID
mapping at runtime when the BIOS messed it up. The only thing I can do
is to check for potential problems and disable the intremap feature
then, so that the system will at least boot.


	Joerg


