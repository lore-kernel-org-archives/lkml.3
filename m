Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3GKCKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab3GKCKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:10:19 -0400
Date: Thu, 11 Jul 2013 03:10:12 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of the device-mapper quilt series
Message-ID: <20130711021012.GL8530@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130711103116.72f41606b87698b476c4d371@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711103116.72f41606b87698b476c4d371@canb.auug.org.au>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 10:31:16AM +1000, Stephen Rothwell wrote:
> You have
> just invalidated your testing 

On the contrary, it is part of my testing.

> Your whole series was already
> based after v3.10 (i.e. released or rebased after the merge window
> opened), so why move it again?
 
I usually base it either on the actual final release, v3.10 in this
case, or, if there are non-trivial conflicts, a suitable commit from a
point after the inclusion of the tree (normally block) leading to the
conflict.

Alasdair

