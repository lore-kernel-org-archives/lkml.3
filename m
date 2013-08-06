Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3HFWKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:10:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47172 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397Ab3HFWKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:10:00 -0400
Date: Wed, 7 Aug 2013 00:09:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, bhelgaas@google.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3 V2] EDAC, AMD64_EDAC: Add ECC decoding support for
 newer F15h models.
Message-ID: <20130806220958.GI14891@pd.tnic>
References: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <1375483384-2302-4-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20130806202323.GH14891@pd.tnic>
 <520162C1.2080603@amd.com>
 <52017213.4000704@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52017213.4000704@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:00:51PM -0500, Aravind Gopalakrishnan wrote:
> Quick question: Shall I change all instances of
> boot_cpu_data.[x86|x86_model] to use pvt->fam and pvt->model wherever
> applicable as part of this patch or have it go in as a separate patch?

Yes, a separate pre-patch would be lovely.

Also, please trim your reply by quoting only the relevant part because
with a huge mail, almost completely quoted like this one, I'm choking in
">" lines trying to find the text you wrote.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
