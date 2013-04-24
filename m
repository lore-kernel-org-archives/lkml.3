Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3DXQYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:24:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab3DXQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:24:08 -0400
Date: Wed, 24 Apr 2013 18:24:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: fix trivial typo in the comment
In-Reply-To: <CAHp75Veyy=YUvLbzNGKskbcPMf-USf9hrYA7W0ihOEK2jk3Gbw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1304241823310.29143@pobox.suse.cz>
References: <1366626999-6270-1-git-send-email-andriy.shevchenko@linux.intel.com> <alpine.LNX.2.00.1304241637530.29143@pobox.suse.cz> <CAHp75Veyy=YUvLbzNGKskbcPMf-USf9hrYA7W0ihOEK2jk3Gbw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Andy Shevchenko wrote:

> >> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
> >> + * This routine returns 0 if the first character is one of 'Yy1Nn0'.
> >>   * Otherwise it will return -EINVAL.  Value pointed to by res is
> >>   * updated upon finding a match.
> >>   */
> >
> > And this is correct because ... ?
> 
> So, in this case it means "if and only if", true?

Yes, and that's in accordance with what the function does, isn't it?

Thanks,

-- 
Jiri Kosina
SUSE Labs
