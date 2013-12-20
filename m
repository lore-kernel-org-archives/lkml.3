Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3LTVvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:51:06 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56802 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab3LTVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:51:04 -0500
Date: Fri, 20 Dec 2013 21:50:56 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, joeyli <jlee@suse.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Message-ID: <20131220215056.GA29501@console-pimps.org>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
 <1387517916.3539.4446.camel@linux-s257.site>
 <52B4B242.5010002@zytor.com>
 <2787644.ytU7M33B4r@vostro.rjw.lan>
 <52B4BA0A.1030902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B4BA0A.1030902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec, at 01:43:38PM, H. Peter Anvin wrote:
> 
> Possibly... will have to investigate.  I would also ask if the same
> applies to the PNP0B0x devices -- all we really need there is the
> presence/absence indication and the I/O port base.

It's worth noting that efi_late_init() exists solely because the ACPI
infrastructure to find the BGRT table isn't available any earlier.

If we could setup ACPI earlier that would be awesome.

-- 
Matt Fleming, Intel Open Source Technology Center
