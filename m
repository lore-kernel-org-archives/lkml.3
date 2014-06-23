Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaFWJxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:53:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51981 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaFWJxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:53:08 -0400
X-IronPort-AV: E=Sophos;i="5.01,529,1400025600"; 
   d="scan'208";a="146346714"
Message-ID: <53A7F8FF.2050309@citrix.com>
Date: Mon, 23 Jun 2014 10:53:03 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>,
        <eshelton@pobox.com>, <hpa@zytor.com>, <ian.campbell@citrix.com>,
        <jbeulich@suse.com>, <jeremy@goop.org>, <konrad.wilk@oracle.com>,
        <matt.fleming@intel.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <stefano.stabellini@eu.citrix.com>, <tglx@linutronix.de>
Subject: Re: [PATCH v6 2/9] arch/x86: Do not access EFI memory map if it is
 not available
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com> <1403299768-9955-3-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1403299768-9955-3-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/14 22:29, Daniel Kiper wrote:
> Do not access EFI memory map if it is not available. At least
> Xen dom0 EFI implementation does not have an access to it.

Could it make one based on the XENMEM_memory_map or
XENMEM_machine_memory_map hypercall?

David
