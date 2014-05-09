Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbaEIVqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:46:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:38908 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbaEIVqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:46:52 -0400
Date: Fri, 9 May 2014 23:47:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Perches <joe@perches.com>
cc: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Andres Freund <andres@anarazel.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Warn on #defines ending in semicolon
In-Reply-To: <1399671106.2912.21.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1405092345480.6261@ionos.tec.linutronix.de>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>  <1399598957-7011-3-git-send-email-andres@anarazel.de>  <20140509075730.GB16058@pd.tnic> <20140509103303.GC16058@pd.tnic> <1399671106.2912.21.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Joe Perches wrote:

> Using a #define ending in a semicolon is poor style

It's not poor style it's simply a bug. Just because it 

> can lead to unexpected code paths being executed.

Thanks,

	tglx
