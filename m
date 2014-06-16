Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaFPUKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:10:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60211 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaFPUKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:10:12 -0400
Date: Mon, 16 Jun 2014 22:10:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 09/13] purgatory: Core purgatory functionality
Message-ID: <20140616201000.GG8170@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-10-git-send-email-vgoyal@redhat.com>
 <20140605200523.GB26110@pd.tnic>
 <20140606195104.GM1526@redhat.com>
 <20140613101713.GD4751@pd.tnic>
 <20140616172538.GB4515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616172538.GB4515@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 01:25:38PM -0400, Vivek Goyal wrote:
> I tried following with CONFIG_KEXEC=n
> 
> ifeq ($(CONFIG_KEXEC),y)
>         $(Q)$(MAKE) $(clean)=arch/x86/purgatory
> endif
> 
> And still "make V=1 clean" shows me that it is going in purgatory dir
> to clean things up.

So add the ifdef for the CONFIG_KEXEC=n .configs.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
