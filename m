Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab3GCUrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:47:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:57965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab3GCUq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:46:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,990,1363158000"; 
   d="scan'208";a="340116356"
From: "Ronciak, John" <john.ronciak@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: RE: [PATCH v2 0/8] Thunderbolt workarounds
Thread-Topic: [PATCH v2 0/8] Thunderbolt workarounds
Thread-Index: AQHOeBtA1zw+fxVX+U+4yVMqNweJnJlTvKyAgAADLwD//57hoIAAgCsA//+NTYA=
Date: Wed, 3 Jul 2013 20:46:57 +0000
Message-ID: <D38E8E86660E514AB505863C19C9287C73E5F18F@ORSMSX102.amr.corp.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130703182900.GA29079@srcf.ucam.org> <20130703183311.GA17340@kroah.com>
 <20130703184434.GA29587@srcf.ucam.org>
 <D38E8E86660E514AB505863C19C9287C73E5F07D@ORSMSX102.amr.corp.intel.com>
 <20130703203542.GA32736@srcf.ucam.org>
In-Reply-To: <20130703203542.GA32736@srcf.ucam.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple does their own thing and do not talk to Intel about it at all. This includes writing special drivers and user-space components.  So we (Intel) don't know so we can't comment about it.  Sorry.

Cheers,
John


> -----Original Message-----
> From: Matthew Garrett [mailto:mjg59@srcf.ucam.org]
> Sent: Wednesday, July 03, 2013 1:36 PM
> To: Ronciak, John
> Cc: Greg Kroah-Hartman; Mika Westerberg; Bjorn Helgaas; Wysocki, Rafael
> J; Jesse Barnes; Yinghai Lu; Penner, Miles J; Allan, Bruce W; Heikki
> Krogerus; Kirill A. Shutemov; linux-kernel@vger.kernel.org; linux-
> acpi@vger.kernel.org; linux-pci@vger.kernel.org; x86@kernel.org
> Subject: Re: [PATCH v2 0/8] Thunderbolt workarounds
> 
> On Wed, Jul 03, 2013 at 07:57:21PM +0000, Ronciak, John wrote:
> > Are you talking about Apple platforms specifically?
> 
> Yeah, that's the specific example.
> 
> --
> Matthew Garrett | mjg59@srcf.ucam.org
