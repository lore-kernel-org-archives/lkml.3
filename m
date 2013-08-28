Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3H1PBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:01:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab3H1PBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:01:38 -0400
Date: Wed, 28 Aug 2013 17:01:34 +0200
From: Michal Marek <mmarek@suse.cz>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 4/5] scripts/checkkconfigsymbols.sh: replace echo -e
 with printf
Message-ID: <20130828150134.GA22320@sepie.suse.cz>
References: <1377203125-22934-1-git-send-email-jcmvbkbc@gmail.com>
 <1377203125-22934-5-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377203125-22934-5-git-send-email-jcmvbkbc@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 12:25:24AM +0400, Max Filippov wrote:
> -e is a non-standard echo option, echo output is
> implementation-dependent when it is used. Replace echo -e
> with printf as suggested by POSIX echo manual.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  scripts/checkkconfigsymbols.sh |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied to kbuild.git#misc.

Thanks,
Michal
