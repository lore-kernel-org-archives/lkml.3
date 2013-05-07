Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3EGKFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:05:12 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41929 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3EGKFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:05:10 -0400
Date: Tue, 7 May 2013 12:04:47 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org
Subject: Re: Build errors caused by modalias generation patch
Message-ID: <20130507100447.GA15044@linux-mips.org>
References: <20130506160253.GA27181@linux-mips.org>
 <87mws8m3eu.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mws8m3eu.fsf@hase.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 07:19:53PM +0200, Andreas Schwab wrote:

> Please try the patch in
> <http://marc.info/?l=linux-kbuild&m=136767800809256&w=2>.

No change in observed behaviour.  I did all my builds in empty object
directories so I don't see why this patch would make any difference.

  Ralf
