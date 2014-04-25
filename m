Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaDYLxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:53:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53651 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaDYLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:53:50 -0400
Date: Fri, 25 Apr 2014 12:53:45 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140425115345.GC26088@console-pimps.org>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr, at 05:36:58PM, Dave Young wrote:
> earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"
 
Are you sure it hangs and it's not just that nothing is output to the
console after that point?

> Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> Thus efi earlyconsole can not be kept.
 
Urgh, good point, that's a bug. However I'm sure I've had this working
in the past and have in fact used it to debug stuff.

Could you try and fix this up so it works with 'keep'?

-- 
Matt Fleming, Intel Open Source Technology Center
