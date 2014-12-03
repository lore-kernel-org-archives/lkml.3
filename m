Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaLCOCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:02:42 -0500
Received: from tex.lwn.net ([70.33.254.29]:35910 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaLCOCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:02:39 -0500
Date: Wed, 3 Dec 2014 09:02:37 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: update headers_install.txt document
Message-ID: <20141203090237.62787e98@lwn.net>
In-Reply-To: <1417589141-14814-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417589141-14814-1-git-send-email-yamada.m@jp.panasonic.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Dec 2014 15:45:41 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> The arch header directories "include/asm-*" were moved long ago.
> Now we should check the existence of arch/*/include/uapi/asm/Kbuild
> to see if an architecture supports the headers installation.
> (Actually, "um" is the only architecture that does not have it.)
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

So please forgive me if I seem overly difficult and fussy, but...  while
I'm all for fancy shell one-liners, wouldn't it be more straightforward,
in this case, to simply say in the documentation that all architectures
other than um have support?

Thanks,

jon
