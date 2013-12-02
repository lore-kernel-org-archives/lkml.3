Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LBJor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:44:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38237 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3LBJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:44:46 -0500
Date: Mon, 2 Dec 2013 10:44:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: toshi.kani@hp.com, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        x86@kernel.org, mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131202094441.GB7380@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131127140732.GD32267@pd.tnic>
 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
 <20131129164632.GD4266@pd.tnic>
 <20131202024914.GD3999@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131202024914.GD3999@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 10:49:15AM +0800, Dave Young wrote:
> All these setup_data passing, remapping etc. is mostly for kexec,
> add a lot of contiditional #if #endif makes the code a mess. I would
> prefer to not do this if you are not strongly object.

Right, having efi_kexec.c could solve all that, see my other mail.

> I'm confused how to connect this with DMI..

This HP platform - like any other platform out there - has specific DMI
strings identifying it. Look for examples calling dmi_check_system().

> Ok, so I will leave this to you after this series settle down.

Ok,

/me puts it on the TODO list :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
