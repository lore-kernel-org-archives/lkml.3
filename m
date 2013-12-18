Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3LRJay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:30:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3LRJav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:30:51 -0500
Date: Wed, 18 Dec 2013 17:29:45 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com,
        akpm@linux-foundation.org, mingo@kernel.org, msalter@redhat.com,
        leif.lindholm@linaro.org
Subject: Re: [PATCH v6 14/14] x86: kdebugfs do not use __va for getting
 setup_data virt addr
Message-ID: <20131218092945.GC15594@dhcp-16-126.nay.redhat.com>
References: <1387186235-15972-1-git-send-email-dyoung@redhat.com>
 <1387186235-15972-15-git-send-email-dyoung@redhat.com>
 <20131216163501.GB3873@console-pimps.org>
 <20131217062417.GE6751@dhcp-16-126.nay.redhat.com>
 <20131217065346.GG6751@dhcp-16-126.nay.redhat.com>
 <20131217112452.GA3145@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217112452.GA3145@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Reproduced it again in normal boot with memmap=exactmap, but I agree it's a corner
> > case, I remember I saw this in kdump kernel, but I still did not see it in today's
> > testing so I think move this issue out of this patch series is fine to me.
>  
> Please include the following oops when you submit this patch again.

Sure, will do if I can reproduce it again in kdump kernel.

Thanks
Dave
