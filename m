Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3JDOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:25:57 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42879 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3JDOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:25:55 -0400
Date: Fri, 4 Oct 2013 22:25:29 +0800
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
Subject: Re: [PATCH v2 3/5] kconfig: adjust warning message for conflicting
 types
Message-ID: <20131004142529.GA5224@udknight>
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
References: <5367004.amEGKp5Frc@tacticalops>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5367004.amEGKp5Frc@tacticalops>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 07:24:46PM +0200, Martin Walch wrote:
> From: Martin Walch <walch.martin@web.de>
> Date: Thu, 3 Oct 2013 18:32:02 +0200
> Subject: [PATCH v2 3/5] kconfig: adjust warning message for conflicting types
> 
> Each symbol must have exactly one type assigned. However, if a symbol happens
> to have two different types assigned at runtime, a warning is printed and the
> first type is preserved while the second type is being ignored.
> 
> The warning message says
> 
> type of <symbol name> redefined from <first type> to <second type>
> 
> which may be misleading as it may create the impression that the second type
> replaces the first type.
> 
> This patch clarifies this by changing the warning to
> 
> ignoring type redefinition of <symbol name> from <first type> to <second type>
> 
> Signed-off-by: Martin Walch <walch.martin@web.de>

Acked-by: Wang YanQing <udknight@gmail.com>
