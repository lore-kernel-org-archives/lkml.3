Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaIITL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:11:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaIITL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:11:56 -0400
Date: Tue, 9 Sep 2014 21:11:21 +0200
From: Borislav Petkov <bp@suse.de>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org,
        christoffer.dall@linaro.org, jan.kiszka@siemens.com,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, marc.zyngier@arm.com,
        bp@suse.de, pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: fix api documentation of KVM_GET_EMULATED_CPUID
Message-ID: <20140909191121.GB7072@nazgul.tnic>
References: <1410280039-2823-1-git-send-email-alex.bennee@linaro.org>
 <1410280039-2823-3-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410280039-2823-3-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:27:19PM +0100, Alex Bennée wrote:
> It looks like when this was initially merged it got accidentally included
> in the following section.

Whoops.

> I've just moved it back in the correct section
> and re-numbered it as other ioctls have been added since.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.
--
