Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbaGDTQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:16:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54661 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbaGDTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:16:40 -0400
Date: Fri, 4 Jul 2014 20:16:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Borislav Petkov <bp@alien8.de>, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        dhowells@redhat.com, pjones@redhat.com
Subject: Re: [PATCH 2/9] Provide PE binary definitions
Message-ID: <20140704191633.GA27756@srcf.ucam.org>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
 <1404421641-12691-3-git-send-email-vgoyal@redhat.com>
 <CAJL_dMuFj7sZA3PMznNbnS6ezjcJ-WbzGkc2PVJKCNK_C3QnDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJL_dMuFj7sZA3PMznNbnS6ezjcJ-WbzGkc2PVJKCNK_C3QnDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 10:12:51PM +0300, Anca Emanuel wrote:
> Wow MZ ? EXE for MSDOS and Windows ???
> 
> After more research, http://en.wikipedia.org/wiki/Portable_Executable
> [quote]PE is a modified version of the Unix COFF (Common Object File
> Format).[/quote]
> 
> How can anyone be sure that Microsoft will not sue about this ?

We already build a kernel that's a valid PE executable for UEFI systems.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
