Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaFJJTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:19:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaFJJTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:19:21 -0400
Date: Tue, 10 Jun 2014 11:16:00 +0200
From: Borislav Petkov <bp@suse.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig
 helper
Message-ID: <20140610091600.GC28607@pd.tnic>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
 <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
 <20140607090430.GA27457@nazgul.tnic>
 <20140609171525.GL22052@wotan.suse.de>
 <1402389339.29301.3.camel@kazak.uk.xensource.com>
 <20140610090125.GB28607@pd.tnic>
 <1402391628.29980.15.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402391628.29980.15.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 10:13:48AM +0100, Ian Campbell wrote:
> NB the overhead I meant was a few kbs of .text and modules, not
> runtime overhead.

Whatever, no thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
