Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966096Ab3E2NVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:21:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965613Ab3E2NVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:21:38 -0400
Date: Wed, 29 May 2013 15:21:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Daniel Nicoletti <dantti12@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] HID: input: return ENODATA if reading battery attrs
 fails
In-Reply-To: <CANq1E4TirOvzsGCXdVFboXWqeFPJYQF3+hp-C8cLYOVsnCFuYQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1305291521120.30576@pobox.suse.cz>
References: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com> <CACo8zOceMMJQPXNLM3JL_GMQh8wNVNDkSC5eBaZf3a=--9JGqA@mail.gmail.com> <CANq1E4TirOvzsGCXdVFboXWqeFPJYQF3+hp-C8cLYOVsnCFuYQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013, David Herrmann wrote:

> So I hope we can apply this for linux-next (probably after gustavo
> applied the HIDP fix)?

Applied to my tree, together with the hidp fix. Thanks David, thanks 
Daniel!

-- 
Jiri Kosina
SUSE Labs
