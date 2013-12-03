Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3LCFFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:05:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51555 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3LCFE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:04:58 -0500
Date: Tue, 3 Dec 2013 05:04:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add efi_whitelist_table to use all efi
 variable storage
Message-ID: <20131203050450.GA30967@srcf.ucam.org>
References: <528DD3E0.3050606@jp.fujitsu.com>
 <1385064722.12107.1.camel@x230>
 <528E9EB2.3060808@jp.fujitsu.com>
 <1385078632.12107.3.camel@x230>
 <528EF87D.4050300@jp.fujitsu.com>
 <528EF9CE.2070305@jp.fujitsu.com>
 <1385142450.2884.1.camel@x230>
 <529D4DF5.80502@jp.fujitsu.com>
 <25e63f3b748741998d2b3e04bbc53064@BN1PR05MB423.namprd05.prod.outlook.com>
 <529D62C0.2080400@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D62C0.2080400@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:49:04PM +0900, Yasuaki Ishimatsu wrote:

> What boot service is the "boot services" in these sentences?

The environment prior to ExitBootServices() being called.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
