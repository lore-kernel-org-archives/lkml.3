Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3JDOTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:19:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49156 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3JDOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:19:04 -0400
Date: Fri, 4 Oct 2013 22:18:24 +0800
From: Wang YanQing <udknight@gmail.com>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] kconfig: fix trivial typos and update mconf
 documentation
Message-ID: <20131004141824.GA3040@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Martin Walch <walch.martin@web.de>, linux-kbuild@vger.kernel.org,
	Michal Marek <mmarek@suse.cz>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Jiri Kosina <trivial@kernel.org>,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Benjamin Poirier <bpoirier@suse.de>,
	Dirk Gouders <dirk@gouders.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
	linux-kernel@vger.kernel.org
References: <7686213.7MfDICRPAE@tacticalops>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7686213.7MfDICRPAE@tacticalops>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 07:24:29PM +0200, Martin Walch wrote:
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

Reviewed-by: Wang YanQing <udknight@gmail.com>

Thanks, I like it. :)
