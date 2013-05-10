Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3EJTrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:47:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33818 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab3EJTrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:47:20 -0400
Date: Fri, 10 May 2013 21:55:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SyS symbol munging.
Message-ID: <20130510195500.GD23014@pd.tnic>
References: <20130510192417.GA4915@redhat.com>
 <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 12:35:10PM -0700, Andrew Morton wrote:
> I forget who did this initially and peeling back those layers with git
> is tiresome.

1a94bc34768e4 from 2009, although those SyS* things started appearing in
stack traces only recently AFAIR.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
