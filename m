Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3KOXPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:15:35 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9120 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3KOXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:15:29 -0500
Message-ID: <1384557052.1791.6.camel@misato.fc.hp.com>
Subject: Re: [patch 2/7 v2] x86 efi: reserve boot service fix
From: Toshi Kani <toshi.kani@hp.com>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, Borislav Petkov <bp@suse.de>
Date: Fri, 15 Nov 2013 16:10:52 -0700
In-Reply-To: <20131105082716.163974996@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
	 <20131105082716.163974996@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 16:20 +0800, dyoung@redhat.com wrote:
> Current code check boot service region with kernel text region by: 
> start+size >= __pa_symbol(_text)
> The end of the above region should be start + size - 1 instead.
> 
> I see this problem in ovmf + Fedora 19 grub boot:
> text start: 1000000 md start: 800000 md size: 800000
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>
> Acked-by: Borislav Petkov <bp@suse.de>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

