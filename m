Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaAMO5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:57:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35253 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaAMO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:57:36 -0500
Date: Mon, 13 Jan 2014 15:57:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Message-ID: <20140113145732.GE5388@pd.tnic>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
 <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
 <20140113101822.GA5388@pd.tnic>
 <20140113122320.GA1900@darkstar.nay.redhat.com>
 <52D3FCAA.7070004@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D3FCAA.7070004@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 06:48:10AM -0800, Arjan van de Ven wrote:
> >MODULE_LICENSE("GPL");
> >MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
> >MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");
>
> personally I consider it good form to always have this kind of
> information in .c files, regardless of the KConfig side of thing...

Agreed.

Let's not touch this unless it is absolutely necessary and until there's
a real reason why it should be touched and not for the sake of the
cleanup itself only.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
