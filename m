Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3BEKyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:54:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab3BEKyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:54:50 -0500
Date: Tue, 5 Feb 2013 11:54:39 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, joe@perches.com
Subject: Re: [TRIVIAL PATCH V2] Doc: percpu_counter doc code for better
 readability
In-Reply-To: <CAOS58YO1VSsbisxSqzcW6n=a+XwcM4F0uHN40OKB9Ok6DSMW7A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1302051154280.2260@pobox.suse.cz>
References: <20130204214952.GJ27963@mtj.dyndns.org> <20130204221356.29548.35746.stgit@dragon> <CAOS58YO1VSsbisxSqzcW6n=a+XwcM4F0uHN40OKB9Ok6DSMW7A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Tejun Heo wrote:

> > Help people reading the percpu_counter code, to notice the ifdef
> > else statement that seperates CONFIG_SMP.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Jiri, can you please take this?

Absolutely, now applied. Thanks,

-- 
Jiri Kosina
SUSE Labs
