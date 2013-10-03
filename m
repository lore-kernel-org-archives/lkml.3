Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3JCVH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:07:27 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55445 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab3JCVHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:07:25 -0400
Date: Thu, 3 Oct 2013 22:07:15 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: Mark Salter <msalter@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Message-ID: <20131003210715.GD2781@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
 <20131003095224.GX21381@console-pimps.org>
 <1380807804.17503.9.camel@deneb.redhat.com>
 <20131003142721.GB2781@console-pimps.org>
 <CAFECyb-=2osh_j_9FCnWjAjLX-xbzanQeFjCLNTz4JKAk5d30w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb-=2osh_j_9FCnWjAjLX-xbzanQeFjCLNTz4JKAk5d30w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct, at 12:28:03PM, Roy Franz wrote:
> Hi Matt,
> 
>    This  function is shared between ARM and ARM64, which are separate
> architectures so to keep this in arch code would require it to be
> duplicated for ARM/ARM64.  Would moving this function to a new
> "efi-stub-fdt.c" file be satisfactory?  This file would just be used
> the ARM and ARM64, so this would remove
> the need for the top-level #ifdefs.

Fair enough, move it to drivers/firmware/efi/fdt.c - there's no need to
prefix it with "efi-" (efi-pstore.c has historic baggage).

-- 
Matt Fleming, Intel Open Source Technology Center
