Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab3GCVAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:00:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab3GCVAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:00:09 -0400
Message-ID: <51D490D4.2080808@suse.cz>
Date: Wed, 03 Jul 2013 23:00:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Rob Landley <rob@landley.net>, cocci@systeme.lip6.fr,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coccinelle: Update information about the minimal version
 required
References: <1372862461-14633-1-git-send-email-nicolas.palix@imag.fr>
In-Reply-To: <1372862461-14633-1-git-send-email-nicolas.palix@imag.fr>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 3.7.2013 16:41, Nicolas Palix napsal(a):
> The naming convention of options has changed one year ago.
> The options have been recently updated in the cocci file
> and in scripts/coccicheck. This patch also adds this information
> in the documentation.
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

I applied this and the patch that changes the options to kbuild.git#misc.

Thanks,
Michal

