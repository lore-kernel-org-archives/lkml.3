Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaGaPrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:47:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49459 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaGaPru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:47:50 -0400
Date: Thu, 31 Jul 2014 17:47:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, pbonzini@redhat.com,
        kvm@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH 1/2] x86: AMD: mark TSC unstable on APU family 15h models
 10h-1fh
Message-ID: <20140731154747.GA7160@pd.tnic>
References: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
 <1406800033-13404-2-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406800033-13404-2-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:47:12AM +0000, Igor Mammedov wrote:
> Due to erratum #778 from
> "Revision Guide for AMD Family 15h Models 10h-1Fh Processors,
>  Publication # 48931, Issue Date: May 2013, Revision: 3.10"
> 
> TSC on affected processor, a core may drift under certain conditions,
> which makes initially synchronized TSCs to become unsynchronized.

Is this something you're seeing on a real system? If so, how do you
trigger this?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
