Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3JZPui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 11:50:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56116 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab3JZPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 11:50:36 -0400
Date: Sat, 26 Oct 2013 16:50:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131026155030.GA1982@console-pimps.org>
References: <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
 <20131012103054.GA13739@pd.tnic>
 <20131013031126.GB1914@darkstar.nay.redhat.com>
 <20131013092521.GA22866@pd.tnic>
 <20131014155851.GJ4009@pd.tnic>
 <20131021124739.GA4515@dhcp-16-126.nay.redhat.com>
 <20131021133741.GA5716@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021133741.GA5716@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Oct, at 03:37:41PM, Borislav Petkov wrote:
> On Mon, Oct 21, 2013 at 08:47:39PM +0800, Dave Young wrote:
> > What's the status of this series?
> 
> They should appear at some point in Matt's efi-next branch, I think.
> 
> > I need below patch for mapping to fixed virt addr passed
> > from 1st kernel.
> 
> You need this to map the runtime regions in the kexec kernel, right?
> Please write that in the commit message.
> 
> > Would you like to add it to your series or I send out it later?
> 
> Yeah, just add it to your patchset.
> 
> > BTW, what tree should my patches based on? Matt's next tree?
> 
> Yeah, I think efi-next. Matt?

Yes please.

-- 
Matt Fleming, Intel Open Source Technology Center
