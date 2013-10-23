Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3JWMh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:37:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57284 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3JWMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:37:27 -0400
Date: Wed, 23 Oct 2013 13:37:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, Matt Fleming <matt@console-pimps.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131023123704.GA29106@srcf.ucam.org>
References: <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
 <20131021150426.GB4515@dhcp-16-126.nay.redhat.com>
 <20131022111857.GA10660@nazgul.tnic>
 <20131023021730.GE4594@dhcp-16-126.nay.redhat.com>
 <20131023122531.GA15848@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023122531.GA15848@nazgul.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 02:25:31PM +0200, Borislav Petkov wrote:

> Matt, didn't you question the need to keep boot services regions
> mapped indefinitely? What was the story there?

We shouldn't need boot services regions to be mapped after 
SetVirtualAddressMap is called.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
