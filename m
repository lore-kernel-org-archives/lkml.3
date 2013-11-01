Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3KALcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:32:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56690 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3KALcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:32:23 -0400
Date: Fri, 1 Nov 2013 12:32:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131101113212.GA7508@pd.tnic>
References: <20131028145801.GM4314@pd.tnic>
 <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
 <20131029023203.GB5185@dhcp-16-126.nay.redhat.com>
 <20131029134302.GI10972@pd.tnic>
 <20131030020348.GA4332@dhcp-16-126.nay.redhat.com>
 <20131030104718.GB13290@pd.tnic>
 <20131031020405.GA4377@dhcp-16-126.nay.redhat.com>
 <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
 <20131031104426.GA10544@pd.tnic>
 <20131101011825.GB4378@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131101011825.GB4378@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 09:18:25AM +0800, Dave Young wrote:
> Great, thank you. BTW, I have managed to test original patch set on a
> Macboot Air of my friend with usb boot, it works ok.

Ok, that's actually a very good news - the apples tend to be special wrt
uefi implementation.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
