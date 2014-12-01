Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbaLAWby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:31:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaLAWbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:31:52 -0500
Date: Mon, 1 Dec 2014 23:31:47 +0100
From: Borislav Petkov <bp@suse.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, gleb@kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on
 paravirt
Message-ID: <20141201223147.GE4730@pd.tnic>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
 <20141201215725.GG24289@laptop.dumpdata.com>
 <547CE7D6.4030601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <547CE7D6.4030601@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:12:38PM +0100, Paolo Bonzini wrote:
> We also do not want to load microcode. :)  Thanks for the heads-up.

You don't need to :P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
