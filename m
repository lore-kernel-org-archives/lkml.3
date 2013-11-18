Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3KRTHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:07:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46279 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab3KRTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:07:33 -0500
Date: Mon, 18 Nov 2013 19:07:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many
 entries to nvram.
Message-ID: <20131118190720.GA20875@srcf.ucam.org>
References: <87fvr3h3b9.fsf@redhat.com>
 <20131111110701.GE22636@console-pimps.org>
 <87eh6nt8oo.fsf@redhat.com>
 <20131113112052.GJ22636@console-pimps.org>
 <878uws1msy.fsf@redhat.com>
 <20131113140647.GK22636@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113140647.GK22636@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 02:08:14PM +0000, Matt Fleming wrote:

> OK, it looks like the firmware Boot Manager gets very confused when it
> tries to parse the Boot Load Option you created with efibootmgr. This
> looks like a general firmware bug and not something we need to worry
> about in the kernel.

Well, we do do some parsing of the boot parameters in the kernel in 
order to avoid hitting a Tianocore bug. But if the problem is just that 
the Dell firmware falls over if it sees something that isn't Unicode, I 
don't think we can really work around that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
