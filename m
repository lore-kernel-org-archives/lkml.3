Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162831Ab3LFNwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:52:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161912Ab3LFNwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:52:03 -0500
Message-ID: <1386337892.1861.158.camel@deneb.redhat.com>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
From: Mark Salter <msalter@redhat.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Date: Fri, 06 Dec 2013 08:51:32 -0500
In-Reply-To: <20131206133827.GB24997@rocoto.smurfnet.nu>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-2-git-send-email-msalter@redhat.com>
	 <20131205141853.GA974@darko.cambridge.arm.com>
	 <1386254603.1861.120.camel@deneb.redhat.com>
	 <20131205152806.GC974@darko.cambridge.arm.com>
	 <20131206122511.301D6C40757@trevor.secretlab.ca>
	 <1386336870.1861.155.camel@deneb.redhat.com>
	 <20131206133827.GB24997@rocoto.smurfnet.nu>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-06 at 14:38 +0100, Leif Lindholm wrote:
> On Fri, Dec 06, 2013 at 08:34:30AM -0500, Mark Salter wrote:
> > > Or just disable runtime services on the switch to big ending. Big endian
> > > should not disable the stub (but getting it to work could be a follow-up
> > > patch)
> > > 
> > The other problem with BE is that the PE/COFF masquerading is built into
> > head.S so the same Image can be used for EFI and non-EFI. I don't see
> > a BE opcode which we could us to provide the magic "MZ" at the start
> > of a BE kernel Image.
> 
> That's actually not an issue.
> Instructions are always LE - endinaness affects only data.
> 

Oh right, I knew that. Time for coffee.


