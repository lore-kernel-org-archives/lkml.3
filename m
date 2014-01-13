Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaAMNSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:18:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaAMNSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:18:02 -0500
Date: Mon, 13 Jan 2014 21:17:37 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 4/4] efi: Make efi virtual runtime map passing more robust
Message-ID: <20140113131737.GB1900@darkstar.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-5-git-send-email-bp@alien8.de>
 <20140113054038.GB11237@dhcp-16-126.nay.redhat.com>
 <20140113102734.GB5388@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113102734.GB5388@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:27:34AM +0100, Borislav Petkov wrote:
> On Mon, Jan 13, 2014 at 01:40:39PM +0800, Dave Young wrote:
> > Adding a safeguard check for desc_size is better though currently it's
> > impossible for the desc_size > PAGE_SIZE?
> 
> Huh, what?
> 
> sizeof(efi_memory_desc_t) is only 40 bytes AFAICT.

I know this is nearly impossible, but is there possible for some corrupted
desc_size value or firmware bug? who knows...

Thanks
Dave
