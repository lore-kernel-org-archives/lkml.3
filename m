Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaLCNWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:22:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaLCNWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:22:11 -0500
Date: Wed, 3 Dec 2014 14:22:06 +0100
From: Michal Marek <mmarek@suse.cz>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: remove redundant -rR flag of hdr-inst
Message-ID: <20141203132206.GA29008@sepie.suse.cz>
References: <1417494646-24528-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417494646-24528-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 01:30:46PM +0900, Masahiro Yamada wrote:
> Passing -rR for "make headers_install" is redundant because
> the top Makefile has already set -rR to MAKEFLAGS.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
> 
>  scripts/Kbuild.include | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks, applied to kbuild.git#kbuild.

Michal
