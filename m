Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaG1Vi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:38:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34017 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaG1Vix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:38:53 -0400
MIME-Version: 1.0
Message-ID: <963f7cc9-3f46-44f6-8fe1-e25fae83c722@default>
Date: Mon, 28 Jul 2014 14:38:23 -0700 (PDT)
From: Daniel Kiper <daniel.kiper@oracle.com>
To: <david.vrabel@citrix.com>
Cc: <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>, <matt.fleming@intel.com>,
        <xen-devel@lists.xenproject.org>, <ian.campbell@citrix.com>,
        <tglx@linutronix.de>, <andrew.cooper3@citrix.com>, <jeremy@goop.org>,
        <hpa@zytor.com>, <jbeulich@suse.com>, <mingo@redhat.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] xen: Silence compiler warnings
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

> On 12/07/14 22:09, Daniel Kiper wrote:
> > Add inline keyword to silence the following compiler
> > warnings if xen_efi_probe() is not used:
>
> The title and should be:
>
>     xen: make stub xen_efi_probe() static inline
>
>     Empty stub functions in headers should be inline or the compiler
>     will warn that it is unused.
>
> Do you want this to go via the Xen tree or the EFI one?

Thanks for your comment but as I can see it was
taken by Matt and now it is a part of tip.

Daniel
