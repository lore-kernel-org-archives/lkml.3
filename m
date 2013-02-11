Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3BKJkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:40:37 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40252 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3BKJkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:40:36 -0500
Date: Mon, 11 Feb 2013 10:40:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 6/7] x86, UV: UV3 Check current gru hub support.
Message-ID: <20130211094032.GD23932@gmail.com>
References: <20130208184305.132404589@gulag1.americas.sgi.com>
 <20130208184306.212373913@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208184306.212373913@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> This patch checks current hub support to avoid panicing the
> system until all the GRU changes for UV3+ are in place.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>

That's a weird signoff sequence. It should either also include a 
From: Dimitri tag at the front, or the Signed-off-by should be 
Acked-by.

Please also use consistent titles in your patches, standardizing 
on this pattern would be nice:

   x86/UV/UV3: Check current gru hub support

while UV patches affecting all UV models would come with a 
'x86/UV:' title or so.

Thanks,

	Ingo
