Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3I3Uf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab3I3Uf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:35:27 -0400
Date: Mon, 30 Sep 2013 16:35:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20130930203505.GA6116@redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
 <20130926031242.GA4487@dhcp-16-126.nay.redhat.com>
 <20130930201730.GD16383@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930201730.GD16383@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 10:17:30PM +0200, Borislav Petkov wrote:
> On Thu, Sep 26, 2013 at 11:12:42AM +0800, Dave Young wrote:
> > If we choose this approach, can we save not only the efi_mapping, but
> > also the fields which will be converted to virt addr, like fw_vendor,
> > runtime, tables? During my test on a HP workstation, the config table
> > item (SMBIOS) also is converted to virt addr though spec only mention
> > fw_vendor/runtime/tables.
> 
> Btw, I was about to ask: how do you pass boot_params to the kexec
> kernel?

kexec-tools in user space prepares the boot_params and passes it to
second kernel.

Thanks
Vivek
