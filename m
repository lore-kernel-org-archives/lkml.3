Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935994Ab3DHNwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:52:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934619Ab3DHNwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:52:43 -0400
Message-ID: <5162CBAA.5020506@suse.cz>
Date: Mon, 08 Apr 2013 15:52:42 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Coccinelle: Restore coccicheck verbosity in ONLINE
 mode (C=1 or C=2)
References: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
In-Reply-To: <1362260188-14138-1-git-send-email-nicolas.palix@imag.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.3.2013 22:36, Nicolas Palix wrote:
> A recent patch have introduce the VERBOSE variable and comments
> now depend on it. However, the message printed for each cocci file
> such not be printed when the ONLINE mode is active, whatever is
> the value of VERBOSE.
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
> ---
>  scripts/coccicheck |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I applied these four to kbuild.git#misc.

Michal

