Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3HEViS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:38:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57651 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab3HEViQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:38:16 -0400
Message-ID: <52001B04.2050806@zytor.com>
Date: Mon, 05 Aug 2013 14:37:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        Laszlo Ersek <lersek@redhat.com>, linux-efi@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130731205431.GG4724@pd.tnic> <1375307727.22084.103.camel@shinybook.infradead.org> <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com> <20130805181225.GH31845@pd.tnic>
In-Reply-To: <20130805181225.GH31845@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 11:12 AM, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 08:50:17AM -0700, Andrew Fish wrote:
>> AFAICT EFI pre-dates kexec merge into mainline by a number of years as
>> SetVirtualaddressMap() was part of EFI 1.0 (previous millennium)
> 
> Ok, fair enough.
> 
>> The EFI to UEFI conversion was placing EFI 1.10 into an industry
>> standard, UEFI 2.0. UEFI is an industry standard so some one just
>> needs to make a proposal to update the spec. The edk2 open source
>> project is not part of the standards body so complaining on this
>> mailing list is not going to get anything changed.
> 
> Right, I don't think that even changing the spec would help - it would
> actually make things worse because then we'd have to differentiate
> between UEFI versions: those which can do SetVirtualaddressMap() more
> than once and the older ones.
> 
> So let's drop the discussion here - it is what it is, it is too late to
> change anything. At least we talked about it. :-)
> 

All of this would be a non-problem if there weren't buggy
implementations which can't run *without* SetVirtualAddressMap().

	-=hpa


