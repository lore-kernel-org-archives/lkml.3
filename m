Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3JaHJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab3JaHJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:09:14 -0400
Date: Thu, 31 Oct 2013 15:07:52 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131031070751.GD4377@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131029064720.GA16009@dhcp-16-126.nay.redhat.com>
 <20131029094033.GA10972@pd.tnic>
 <20131030093227.GA5791@dhcp-16-126.nay.redhat.com>
 <20131030104526.GA13290@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030104526.GA13290@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/13 at 11:45am, Borislav Petkov wrote:
> On Wed, Oct 30, 2013 at 05:32:27PM +0800, Dave Young wrote:
> > Boris, thanks for update, it's very elaborate, I have still wonder if
> > 32 bit case should be mentioned as well.
> 
> Ah, so that's why is mfleming bugging me about it on IRC :)
> 
> Well, I left out the 32-bit case simply because I don't think anyone
> cares about it.

Ok, that's fine, thanks for telling me.

> 
> > Waiting for you next version of the patch series. I will redo my
> > patches based on that.
> 
> Since I'm doing only minor fixups, I didn't want to spam
> the lists again.
> 
> The latest version is my 'efi' branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git
> 
> and you can pull it from there.

Just pulled your git, the function comment has not yet to be updated,
so could you send me privately your new patches if you would not update
in list.

--
Thanks a lot!
Dave
