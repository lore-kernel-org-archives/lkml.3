Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3EVLS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3EVLS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:18:56 -0400
Date: Wed, 22 May 2013 13:18:50 +0200
From: Borislav Petkov <bp@suse.de>
To: Dirk Gouders <dirk@gouders.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/lib/lk: redefinition of _FORTIFY_SOURCE (gcc-4.7.2)
Message-ID: <20130522111850.GA15091@pd.tnic>
References: <giy5b7uyfe.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <giy5b7uyfe.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 22, 2013 at 12:00:21PM +0200, Dirk Gouders wrote:
> CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC

it seems someone else hit this already and fixed it too:

commit d2f32479e5526a1ab3b4e43910fcb279871524ce
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Sun Feb 17 16:03:36 2013 +0100

    perf tools: check if -DFORTIFY_SOURCE=2 is allowed

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
