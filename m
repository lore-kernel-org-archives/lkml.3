Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3JERyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:54:51 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55807 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3JERyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:54:49 -0400
Date: Sun, 6 Oct 2013 01:54:20 +0800
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
Subject: Re: [PATCH v2 5/5] kconfig: fix bug in search results string: use
 strlen(gstr->s), not gstr->len
Message-ID: <20131005175420.GA28058@udknight>
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
References: <2458916.eNjWPdyz4y@tacticalops>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2458916.eNjWPdyz4y@tacticalops>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 07:25:53PM +0200, Martin Walch wrote:
> From: Martin Walch <walch.martin@web.de>
> Date: Thu, 3 Oct 2013 18:35:16 +0200
> Subject: [PATCH v2 5/5] kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len
> 
> The struct gstr has a capacity that may differ from the actual string length.
> 
> However, a string manipulation in the function search_conf made the assumption
> that it is the same, which led to messing up some search results, especially
> when the content of the gstr in use had not yet reached at least 63 chars.
> 
> Signed-off-by: Martin Walch <walch.martin@web.de>
Acked-by: Wang YanQing <udknight@gmail.com>

Thanks.
