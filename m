Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaLBO65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:58:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaLBO6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:58:55 -0500
Date: Tue, 2 Dec 2014 15:58:52 +0100
From: Borislav Petkov <bp@suse.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        david.vrabel@citrix.com, konrad.wilk@oracle.com, pbonzini@redhat.com,
        gleb@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on
 paravirt
Message-ID: <20141202145852.GA14770@pd.tnic>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
 <20141201220057.GC4730@pd.tnic>
 <547CEC5C.9070201@oracle.com>
 <20141201223708.GF4730@pd.tnic>
 <547DCE78.1020906@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <547DCE78.1020906@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:36:40AM -0500, Boris Ostrovsky wrote:
> All tests passed.

Thanks!

> I wonder whether we should prevent all guests (not just paravirt) from
> loading microcode driver (and from doing early microcode loading).

I don't think the unmodified ones need to. At least I haven't seen any
issues so far.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
