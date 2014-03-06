Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaCFVvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:51:04 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41235 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaCFVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:51:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140306214356.GA16376@dhcp-26-207.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
	<2ba22558b5db90740d5833c35570c3e7cc1e359e.1394128952.git.agordeev@redhat.com>
	<CAPcyv4jW19zxApviDdbofbXB1OvvN2sCriL3Paszfk9o3T8x0w@mail.gmail.com>
	<20140306214356.GA16376@dhcp-26-207.brq.redhat.com>
Date: Thu, 6 Mar 2014 13:50:59 -0800
Message-ID: <CAPcyv4ivvxHvyT_5oybVvRJAUKABQQ1ZH4Eua-1KVDeri5kpkA@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND 1/4] ioat: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 1:43 PM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Thu, Mar 06, 2014 at 01:09:39PM -0800, Dan Williams wrote:
>> Can you point me to the background for this change.  From the
>> changelog I have no idea what this patch does or why I need to apply
>> it.
>
> Function pci_enable_msix() returns a tri-state value while
> pci_enable_msi_exact() is a canonical zero/-errno variant.
> The former is being phased out in favor of the latter.
> In case of 'ioat' there (should be) no difference.

Got it.  If you resend with that in the changelog.

Acked-by: Dan Williams <dan.j.williams@intel.com>
