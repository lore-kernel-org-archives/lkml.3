Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3GPOeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:34:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3GPOeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:34:05 -0400
Subject: Re: [PATCH 3/3] kconfig: cleanup symbol-search code
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <1373738905-23396-4-git-send-email-yann.morin.1998@free.fr>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
	 <1373738905-23396-4-git-send-email-yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 16 Jul 2013 16:33:47 +0200
Message-ID: <1373985227.4513.12.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 13 July 2013 à 20:08 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> - no need for a double-indirection for the temporary sym_match_arr array
> - the temporary sym_match_arr array is not NULL terminated, so no need
>   to allocate n+1 elements
> - two minor style fixes
> - grammar fix in comment
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
>  scripts/kconfig/symbol.c | 39 +++++++++++++++------------------------
>  1 file changed, 15 insertions(+), 24 deletions(-)
>  (...)

You mixed style cleanups with actual code changes, which is usually
avoided. Michal may ask you to split these changes into two separate
patches.

Still, I'm happy with all the changes:

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
Suse L3

