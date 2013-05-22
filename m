Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3EVNvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:51:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3EVNu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:50:59 -0400
Date: Wed, 22 May 2013 15:50:52 +0200
From: Borislav Petkov <bp@suse.de>
To: Dirk Gouders <dirk@gouders.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/lib/lk: redefinition of _FORTIFY_SOURCE (gcc-4.7.2)
Message-ID: <20130522135052.GB15091@pd.tnic>
References: <giy5b7uyfe.fsf@karga.hank.lab>
 <20130522111850.GA15091@pd.tnic>
 <gimwrnuue6.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <gimwrnuue6.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:27:29PM +0200, Dirk Gouders wrote:
> Yes, I should have checked the whole log and not just for one file.
> And please ignore my other mail which I sent just when yours arrived
> ;-)

No problem at all - I didn't see the fix either until I started looking
at the Makefile so it was a good exersise for both of us.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
