Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaFPKwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:52:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9776 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaFPKwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:52:38 -0400
X-IronPort-AV: E=Sophos;i="5.01,486,1400025600"; 
   d="scan'208";a="143685812"
Message-ID: <539ECC71.7080008@citrix.com>
Date: Mon, 16 Jun 2014 11:52:33 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <mjg59@srcf.ucam.org>, <jeremy@goop.org>, <matt.fleming@intel.com>,
        <ian.campbell@citrix.com>, <andrew.cooper3@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <david.vrabel@citrix.com>, <jbeulich@suse.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <eshelton@pobox.com>
Subject: Re: [Xen-devel] [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/14 18:00, Daniel Kiper wrote:
> Introduce EFI_NO_DIRECT flag.

EFI_PARAVIRT would be a clearer name I think.

> +#define EFI_NO_DIRECT		6	/* Can we access EFI directly? */

#define EFI_PARAVIRT 6 /* Access is via a paravirt interface */

David
