Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaJBNOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:14:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbaJBNOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:14:22 -0400
Message-ID: <542D4FAC.5080706@suse.cz>
Date: Thu, 02 Oct 2014 15:14:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: simplify build, clean, modbuiltin shorthands
References: <1410260638-23559-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1410260638-23559-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-09 13:03, Masahiro Yamada wrote:
> $(if $(KBUILD_SRC),$(srctree)/) was a useful strategy
> to omit a long absolute path for in-source-tree build
> prior to commit 890676c65d699db3ad82e7dddd0cf8fb449031af
> (kbuild: Use relative path when building in the source tree).

I think it was quite pointless even back then :).


> Now $(srctree) is "." when building in the source tree.
> It would not be annoying to add "$(srctree)/" all the time.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Applied to kbuild.git#kbuild, thanks.

Michal
