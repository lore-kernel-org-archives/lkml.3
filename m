Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3GCNg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:36:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab3GCNgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:36:55 -0400
Message-ID: <51D428F4.6020003@suse.cz>
Date: Wed, 03 Jul 2013 15:36:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Coccinelle: Update the options used to the new option
 scheme
References: <1371726656-24928-1-git-send-email-nicolas.palix@imag.fr> <1371726656-24928-2-git-send-email-nicolas.palix@imag.fr>
In-Reply-To: <1371726656-24928-2-git-send-email-nicolas.palix@imag.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.6.2013 13:10, Nicolas Palix wrote:
> spatch has changed its option scheme.
> E.g., --no_show_diff is now --no-show-diff
> 
> This patch updates:
>  - scripts/coccicheck
>  - Semantic patches under scripts/coccinelle/

Will the new syntax work with older spatch versions? I mean, it's
probably fair to require a recent version, but it should be documented IMO.

Also, there was no patch 2/3 in this series, only 1/3 and 3/3.

Thanks,
Michal
