Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab3GCVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:21:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59124 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab3GCVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:21:19 -0400
Date: Wed, 3 Jul 2013 22:21:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Ronciak, John" <john.ronciak@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 0/8] Thunderbolt workarounds
Message-ID: <20130703212108.GA884@srcf.ucam.org>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130703182900.GA29079@srcf.ucam.org>
 <20130703183311.GA17340@kroah.com>
 <20130703184434.GA29587@srcf.ucam.org>
 <D38E8E86660E514AB505863C19C9287C73E5F07D@ORSMSX102.amr.corp.intel.com>
 <20130703203542.GA32736@srcf.ucam.org>
 <D38E8E86660E514AB505863C19C9287C73E5F18F@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D38E8E86660E514AB505863C19C9287C73E5F18F@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:46:57PM +0000, Ronciak, John wrote:
> Apple does their own thing and do not talk to Intel about it at all. This includes writing special drivers and user-space components.  So we (Intel) don't know so we can't comment about it.  Sorry.

The hardware has an Intel part number, so I'm pretty sure someone there 
has some idea what the register map looks like.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
