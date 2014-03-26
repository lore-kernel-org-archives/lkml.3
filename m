Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaCZN5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:57:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39419 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbaCZN53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:57:29 -0400
Date: Wed, 26 Mar 2014 13:57:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>, david.vrabel@citrix.com,
        ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org, fenghua.yu@intel.com, matt.fleming@intel.com,
        tony.luck@intel.com, x86@kernel.org, tglx@linutronix.de,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, eshelton@pobox.com, mingo@redhat.com,
        linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range() on
 native EFI platform only
Message-ID: <20140326135723.GG24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
 <20140326130009.GB24856@console-pimps.org>
 <5332E2B9020000780000255D@nat28.tlf.novell.com>
 <20140326133119.GD24856@console-pimps.org>
 <5332E6AE02000078000025F0@nat28.tlf.novell.com>
 <20140326134845.GN3454@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140326134845.GN3454@olila.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar, at 02:48:45PM, Daniel Kiper wrote:
> 
> On my machine this function crashes on Xen so that is why I have changed
> condition. However, if you say that this issue could be solved in
> another way I will investigate it further.

Daniel, could you paste the crash? Do you get a stack trace?

-- 
Matt Fleming, Intel Open Source Technology Center
