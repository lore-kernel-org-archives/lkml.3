Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3LKLCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:02:20 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:49054 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LKLCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:02:13 -0500
Date: Wed, 11 Dec 2013 12:02:27 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        toshi.kani@hp.com, Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v5 02/14] efi: use early_memremap and early_memunmap
Message-ID: <20131211110227.GK22356@rocoto.smurfnet.nu>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-3-git-send-email-dyoung@redhat.com>
 <20131211103903.GC19196@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211103903.GC19196@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 10:39:03AM +0000, Matt Fleming wrote:
> Leif, Mark, does this patch look OK for ARM? We'd need to introduce a
> new early_memunmap() function so that things still build, but that
> should be straight forward. You'd even be able to get rid of the
> asymmetry in uefi_init() where you map efi.systab with early_memremap()
> but unmap it with early_iounmap().

This patch looks splendid for ARM. As long as Mark can get the new
function into an update to the early_*remap() set, I can include this
in my next version - which is coming this week.

/
    Leif
