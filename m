Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3J3Kpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:45:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3J3Kpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:45:33 -0400
Date: Wed, 30 Oct 2013 11:45:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131030104526.GA13290@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131029064720.GA16009@dhcp-16-126.nay.redhat.com>
 <20131029094033.GA10972@pd.tnic>
 <20131030093227.GA5791@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131030093227.GA5791@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 05:32:27PM +0800, Dave Young wrote:
> Boris, thanks for update, it's very elaborate, I have still wonder if
> 32 bit case should be mentioned as well.

Ah, so that's why is mfleming bugging me about it on IRC :)

Well, I left out the 32-bit case simply because I don't think anyone
cares about it.

> Waiting for you next version of the patch series. I will redo my
> patches based on that.

Since I'm doing only minor fixups, I didn't want to spam
the lists again.

The latest version is my 'efi' branch at
git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git

and you can pull it from there.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
