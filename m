Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaAPOw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:52:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:11930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaAPOwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:52:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="466145747"
Message-ID: <52D7F220.5090201@linux.intel.com>
Date: Thu, 16 Jan 2014 06:52:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
References: <20140113122320.GA1900@darkstar.nay.redhat.com> <52D3FCAA.7070004@linux.intel.com> <20140114014003.GB4327@dhcp-16-126.nay.redhat.com> <52D57F75.7060308@zytor.com> <20140115011609.GD23767@dhcp-16-126.nay.redhat.com> <52D6970D.3050701@zytor.com> <20140116014457.GA3807@dhcp-16-126.nay.redhat.com> <52D746D9.7030206@linux.intel.com> <20140116030343.GF3807@dhcp-16-126.nay.redhat.com> <52D75A55.2080503@zytor.com> <20140116064627.GC6356@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20140116064627.GC6356@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If the *module* is really a nonmodule, IMHO it should add the information to
> or add other macros macros instead of reuse the MODULE_*.
>
> BTW, for macros in this file, for a nonmodule "license GPL" is unnecessary at all.

I really fail to see what you have against machine-and-human readable data


