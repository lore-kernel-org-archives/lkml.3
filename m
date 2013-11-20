Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3KTPzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:55:52 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:39446 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3KTPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:55:46 -0500
Date: Wed, 20 Nov 2013 10:50:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 05/29] PCI/MSI: Fix return value when
 populate_msi_sysfs() failed
Message-ID: <20131120155035.GE28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <0607a740e8df7971c8132ef68f8c8a7bbdd6a181.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0607a740e8df7971c8132ef68f8c8a7bbdd6a181.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 07:12:05PM +0200, Alexander Gordeev wrote:
> If populate_msi_sysfs() function failed msix_capability_init()
> must return the error code, but it returns the success instead.
> This update fixes the described misbehaviour.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
