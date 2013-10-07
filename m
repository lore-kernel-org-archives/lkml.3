Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3JGNoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:44:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab3JGNoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:44:11 -0400
Date: Mon, 7 Oct 2013 09:43:58 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Martin Walch <walch.martin@web.de>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Dirk Gouders <dirk@gouders.net>, Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kconfig: fix bug in search results string: use
 strlen(gstr->s), not gstr->len
Message-ID: <20131007134358.GA10523@d2.synalogic.ca>
References: <2458916.eNjWPdyz4y@tacticalops>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2458916.eNjWPdyz4y@tacticalops>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/03 19:25, Martin Walch wrote:
> From: Martin Walch <walch.martin@web.de>
> Date: Thu, 3 Oct 2013 18:35:16 +0200
> Subject: [PATCH v2 5/5] kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len
> 

Good catch, thank you.

Acked-by: Benjamin Poirier <bpoirier@suse.de>
