Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaESOFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:05:52 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57459 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaESOFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:05:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ZvAFJ+ex8ApD1e3gaSQyBAY5tCDaXVi0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 70424579C5E
Date: Mon, 19 May 2014 10:05:47 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jake Edge <jake@lwn.net>
Cc: Anton Saraev <antonysaraev@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/06] staging: crypto: skein: rename files
Message-ID: <20140519140547.GG27822@titan.lakedaemon.net>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
 <cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
 <b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
 <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
 <a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
 <20140519072926.3a05fe08@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519072926.3a05fe08@chukar.edge2.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 07:29:26AM -0600, Jake Edge wrote:
> On Mon, 19 May 2014 12:09:59 +0400 Anton Saraev wrote:
> 
> > rename drivers/staging/skein/{skeinBlockNo3F.c =>
> > skein_block_no_3f.c} (99%)
> 
> fwiw, this file (skeinBlockNo3F.c) seems to be unused ... it kind of looks
> like a temporary file that got checked in by mistake.  It's probably worth
> deleting it in this patch or a separate one, it seems to me.

Correct.  It was a part of the reference implementation I started with.
It's never actually compiled.  I'm not sure what it's purpose was in the
reference implementation, either.

thx,

Jason.
