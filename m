Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3LKMha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:37:30 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53352 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab3LKMh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:37:29 -0500
Date: Wed, 11 Dec 2013 12:37:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v5 00/14] kexec kernel efi runtime support
Message-ID: <20131211123723.GC29980@console-pimps.org>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <20131210152549.7975e3ac25d854e2ada63221@linux-foundation.org>
 <20131210233207.GI31437@pd.tnic>
 <52A7A5D9.9030504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A7A5D9.9030504@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec, at 03:38:01PM, H. Peter Anvin wrote:
> My intent was to pick them into a separate branch of the tip tree either
> directly or via Matt (since Matt feeds us anyway.)
> 
> But yes, work is still underway, although it is getting there.

Yeah, I've only found a few minor nits this time. I'll merge this soon -
presumably after the next revision.

-- 
Matt Fleming, Intel Open Source Technology Center
