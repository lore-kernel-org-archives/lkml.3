Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3ILMp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:45:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52027 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3ILMp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:45:26 -0400
Date: Thu, 12 Sep 2013 14:46:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] buildtar: Add ARCH to the archive name
Message-ID: <20130912124602.GA9280@x1.alien8.de>
References: <1362557147-14393-1-git-send-email-bp@alien8.de>
 <20130307110659.GC22602@8bytes.org>
 <20130307110910.GA5834@pd.tnic>
 <5162CEC1.5070400@suse.cz>
 <20130408142600.GF4395@pd.tnic>
 <CAKA=qzZRfSD33u4cXvpnzQn5isNB4iNY4cibeAwY46gyFmMHhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKA=qzZRfSD33u4cXvpnzQn5isNB4iNY4cibeAwY46gyFmMHhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 06:35:08PM -0500, Josh Hunt wrote:
> I didn't take the time to build the rpm pkg, but deb-pkg produces files
> like:
> 
> linux-image-3.10.0-rc7_3.10.0-rc7-26_amd64.deb
> 
> tarbz2-pkg now produces files with the name of:
> linux-3.10.0-rc7-x86.tar.bz2

Right, I'm not really happy with this solution too because builds which
don't supply ARCH on the command line add "x86" to the archive name
and my intention was to have either "i386" or "x86_64" appended to the
archive name so that when building a bunch of different kernel packages,
I can know which is 32-bit and which is 64-bit.

Having it say "x86" doesn't tell me all that much. Whether it has "-" or
an "_" prepended I don't care.

So I'll go and revisit this thing. I'll add you to CC for feedback since
your script got broke :)

And, btw, other suggestions are appreciated too.

Thanks.

-- 
Regards/Gruss,
Boris.
