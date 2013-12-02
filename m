Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3LBCiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:38:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab3LBCit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:38:49 -0500
Date: Mon, 2 Dec 2013 10:38:01 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 08/12] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Message-ID: <20131202023801.GC3999@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-9-git-send-email-dyoung@redhat.com>
 <20131127102701.GD18170@console-pimps.org>
 <20131127142726.GE32267@pd.tnic>
 <20131129085050.GF4186@dhcp-16-126.nay.redhat.com>
 <20131129164736.GE4266@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129164736.GE4266@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/13 at 05:47pm, Borislav Petkov wrote:
> On Fri, Nov 29, 2013 at 04:50:50PM +0800, Dave Young wrote:
> > It's for debugging purpose, I think it's helpful.
> 
> Why? The first kernel did dump it already.

As for the efi printk though 1st kernel already printed them out, but kexec kernel
context is diffrent from 1st kernel, it's a fresh reboot we do need reprint them.

I think kexec reboot is just like a normal reboot from user's point of view.

Thanks
Dave
