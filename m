Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3JBXmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:42:31 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49967 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3JBXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:42:29 -0400
Date: Wed, 2 Oct 2013 16:42:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Martin Walch <walch.martin@web.de>
cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kconfig: add short explanation to SYMBOL_WRITE
In-Reply-To: <2034014.asIXrEbcsn@tacticalops>
Message-ID: <alpine.DEB.2.02.1310021641280.9096@chino.kir.corp.google.com>
References: <4542076.yVG8YKgu5r@tacticalops> <alpine.DEB.2.02.1310012236360.5682@chino.kir.corp.google.com> <2034014.asIXrEbcsn@tacticalops>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Oct 2013, Martin Walch wrote:

> So, if I have not missed anything, SYMBOL_WRITE decides whether to write a symbol
> to .config or not. This does not necessarily mean that the user can change the value.
> SYMBOL_WRITE may be set and the symbol may be written to .config while the user
> does not even see the corresponding prompt.
> 

The purpose of SYMBOL_WRITE is in sym_calc_value() where it is set if the 
config symbol is visible and settable by the user, which is why I 
suggested it be specified as being writable by the user.
