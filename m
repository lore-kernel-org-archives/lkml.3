Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaFPKyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:54:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:55330 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbaFPKyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:54:08 -0400
X-IronPort-AV: E=Sophos;i="5.01,486,1400025600"; 
   d="scan'208";a="144015171"
Message-ID: <539ECCCC.4030601@citrix.com>
Date: Mon, 16 Jun 2014 11:54:04 +0100
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
Subject: Re: [Xen-devel] [PATCH v5 3/7] xen: Define EFI related stuff
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-4-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1402678823-24589-4-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/14 18:00, Daniel Kiper wrote:
> Define constants and structures which are needed to properly
> execute EFI related hypercall in Xen dom0.
> 
> This patch is based on Jan Beulich and Tang Liang work.
> 
> v5 - suggestions/fixes:

This version information should be after a '---' marker.

> +	struct {
> +		GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
> +		xen_ulong_t size;
> +		GUEST_HANDLE(void) data;
> +		struct xenpf_efi_guid {
> +			uint32_t data1;
> +			uint16_t data2;
> +			uint16_t data3;
> +			uint8_t data4[8];
> +			} vendor_guid;

Indentation looks all messed up here and in many other places.

David
