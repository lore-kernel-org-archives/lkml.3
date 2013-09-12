Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3ILOlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:41:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51745 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3ILOla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:41:30 -0400
Date: Thu, 12 Sep 2013 16:42:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>,
        "d.kasatkin@samsung.com" <d.kasatkin@samsung.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
Message-ID: <20130912144207.GA10495@x1.alien8.de>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
 <522FA2A8.8080703@zytor.com>
 <20130911114419.GB31551@x1.alien8.de>
 <20130911134534.GB15364@redhat.com>
 <20130911143216.GA933@x1.alien8.de>
 <20130912064930.GA5288@dhcp-16-126.nay.redhat.com>
 <20130912125350.GB9280@x1.alien8.de>
 <1378996498.945.4.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1378996498.945.4.camel@x230.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:34:58PM +0000, Matthew Garrett wrote:
> The second kernel still needs to be passed a pointer to the EFI tables
> and memory map.

Date: Thu, 12 Sep 2013 14:53:50 +0200
From: Borislav Petkov <bp@alien8.de
Message-ID: <20130912125350.GB9280@x1.alien8.de>

On Thu, Sep 12, 2013 at 03:34:15PM +0800, Dave Young wrote:
> Also kexec userspace need to fill efi_info in bootparams and pass the
> previous saved efi data to 2nd kernel.

Hmm, yes, we need to tell the kexec kernel the EFI regions.

-- 
Regards/Gruss,
Boris.
