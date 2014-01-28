Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaA1Tiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:38:55 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:56505 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaA1Tit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:38:49 -0500
Date: Tue, 28 Jan 2014 15:38:37 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Roger Pau Monne <roger.pau@citrix.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] xen-blkback: bug fixes
Message-ID: <20140128193837.GA32072@andromeda.dapyr.net>
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:43:32PM +0100, Roger Pau Monne wrote:
> blkback bug fixes for memory leaks (patches 1 and 2) and a race 
> (patch 3).

They all look OK to me. I've stuck them in my 'stable/for-jens-3.14'
branch and are testing them now (hadn't pushed it yet).

Matt and Matt,

Could you take a look at the other two patches as well?

David, Boris,

Are you OK with pushing those patches out to Jens Axboe if nobody
gives an NACK by Friday?

> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
