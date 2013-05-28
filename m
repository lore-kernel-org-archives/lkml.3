Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab3E1H7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:59:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39308 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246Ab3E1H7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:59:17 -0400
Date: Tue, 28 May 2013 09:59:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86/UV: GRU distributed mode mappings
Message-ID: <20130528075912.GA29336@gmail.com>
References: <20130523155013.GA16496@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523155013.GA16496@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> Setup mappings for GRU distributed mode and include them as untracked
> pat ranges.

Would be nice to have the customary changelog content:

  " Current code does (A), this has a problem when (B).
    We can improve this doing (C), because (D)."

Or so - your changelog is pretty light on the 'why' aspect.

Thanks,

        Ingo
