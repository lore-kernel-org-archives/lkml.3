Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3J0KuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 06:50:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45904 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3J0KuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 06:50:15 -0400
Date: Sun, 27 Oct 2013 11:50:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: dyoung@redhat.com, Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 2/6] x86 efi: reserve boot service fix
Message-ID: <20131027105009.GA21868@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 11:47:15AM +0800, dyoung@redhat.com wrote:
> Current code check boot service region with kernel text region by: 
> start+size >= __pa_symbol(_text)
> The end of the above region should be start + size - 1 instead.
> 
> I see this problem in ovmf + Fedora 19 grub boot:
> text start: 1000000 md start: 800000 md size: 800000
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>

Btw, Matt, this being a bugfix and all, shouldn't it be tagged for
stable?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
