Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaCGKMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:12:16 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48435 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaCGKMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:12:10 -0500
Date: Fri, 7 Mar 2014 02:11:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Fleming <matt@console-pimps.org>
cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 00/13] EFI mixed mode
In-Reply-To: <20140306214014.GA8942@console-pimps.org>
Message-ID: <alpine.DEB.2.02.1403070211280.31668@chino.kir.corp.google.com>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.02.1403061325250.25499@chino.kir.corp.google.com> <20140306214014.GA8942@console-pimps.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Matt Fleming wrote:

> Thanks for the report David.
> 
> I sent a pull request that fixes these errors up. Looks like it got
> pulled into tip:x86/efi,
> 
> commit 617b3c37da78
> Merge: 994448f1afa6 3db4cafdfd05
> Author: Matt Fleming <matt.fleming@intel.com>
> Date:   Wed Mar 5 18:18:50 2014 +0000
> 
>     Merge branch 'mixed-mode' into efi-for-mingo
> 
> So everything should be working in tip:x86/efi which includes
> tip:x86/efi-mixed.
> 

You're absolutely right, x86/efi looks good!  Thanks Matt.
