Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966217Ab3E2TWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:22:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60949 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3E2TWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:22:43 -0400
Date: Wed, 29 May 2013 21:22:08 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] pktcdvd fix
Message-ID: <20130529192208.GK22724@kernel.dk>
References: <alpine.LNX.2.00.1305291540300.30576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305291540300.30576@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29 2013, Jiri Kosina wrote:
> Jens,
> 
> please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-jens
> 
> to receive one pktcdvd fix. It fixes a highly theoretical issue with using 
> pktcdvd to work with media that'd be larger than 2TB :) But it's a correct 
> fix and makes static checkers shut up about improperly cleaning upper 
> 32bits.

Thanks, pulled.

-- 
Jens Axboe

