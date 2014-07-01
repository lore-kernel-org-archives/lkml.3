Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaGANNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:13:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56953 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbaGANNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:13:14 -0400
X-IronPort-AV: E=Sophos;i="5.01,581,1400025600"; 
   d="scan'208";a="148894150"
Message-ID: <53B2B3E6.1080203@citrix.com>
Date: Tue, 1 Jul 2014 14:13:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>
CC: <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>,
        <eshelton@pobox.com>, <fenghua.yu@intel.com>, <hpa@zytor.com>,
        <ian.campbell@citrix.com>, <jbeulich@suse.com>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <matt.fleming@intel.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <stefano.stabellini@eu.citrix.com>,
        <tglx@linutronix.de>, <tony.luck@intel.com>
Subject: Re: [PATCH v7 00/10] xen: Add EFI support
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/14 18:52, Daniel Kiper wrote:
> Hey,
> 
> This patch series adds EFI support for Xen dom0 guests.
> It is based on Jan Beulich and Tang Liang work. I was
> trying to take into account all previous comments,
> however, if I missed something sorry for that.

What's changed in this version?

David
