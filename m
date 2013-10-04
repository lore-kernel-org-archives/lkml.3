Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3JDHDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:03:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab3JDHDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:03:36 -0400
Subject: Re: [PATCH v2 2/5] kconfig: fix trivial typos and update mconf
 documentation
From: Jean Delvare <jdelvare@suse.de>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
In-Reply-To: <7686213.7MfDICRPAE@tacticalops>
References: <7686213.7MfDICRPAE@tacticalops>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 04 Oct 2013 09:02:49 +0200
Message-ID: <1380870169.4598.1.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Le Thursday 03 October 2013 à 19:24 +0200, Martin Walch a écrit :
> From: Martin Walch <walch.martin@web.de>
> Date: Thu, 3 Oct 2013 17:28:14 +0200
> Subject: [PATCH v2 2/5] kconfig: fix trivial typos and update mconf documentation
> 
> This fixes lots of typos in comments and strings.
> 
> It also updates the documentation strings in mconf to reflect the changes in
> the user interface from the two commits
> 
> 6364fd0cb1e4c7f72b974613e0cf5744ae4d2cb2
>   menuconfig: Add Save/Load buttons
> 1bdbac478a858d2aa73a6784c7c2e09de0f6d06b
>   menuconfig: Get rid of the top-level entries for "Load an Alternate/Save an Alternate"
> 
> And it updates the layout of the example search result, i. e. moves down the
> "Defined at" and "Depends on" lines and adds a symbol state ([=n]) to the
> symbol in the "Selected by" line.
> 
> Furthermore, the help texts now should fit in 80 columns again when viewed
> in mconf.
> 
> Signed-off-by: Martin Walch <walch.martin@web.de>

Looks good to me.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
Suse L3

