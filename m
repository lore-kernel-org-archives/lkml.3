Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3JBPog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:44:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34960 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab3JBPoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:44:34 -0400
Message-ID: <524C3F38.6050507@zytor.com>
Date: Wed, 02 Oct 2013 08:43:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
References: <1379602494-26684-1-git-send-email-bp@alien8.de> <1379602494-26684-12-git-send-email-bp@alien8.de> <20130921113929.GB1587@pd.tnic> <20130922123515.GA7476@dhcp-16-126.nay.redhat.com> <20130922133722.GC28718@pd.tnic> <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com> <20130924025209.GA5561@dhcp-16-126.nay.redhat.com> <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com> <20131002100426.GB20568@pd.tnic>
In-Reply-To: <20131002100426.GB20568@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 03:04 AM, Borislav Petkov wrote:
> When we start allocating from -4G, i.e. 0xffffffff00000000, I think we
> want to do it bottom-up so that 0xffffffff00000000 is the *last*, i.e.
> lowest address. Because we link the kernel text at 0xffffffff81000000 by
> default, which would mean, if -4G was the first address, we'll have only
> 2G:

Right.

	-hpa


