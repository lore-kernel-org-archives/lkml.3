Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaIDVZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:25:45 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:42737 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaIDVZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:25:44 -0400
Date: Fri, 5 Sep 2014 00:25:35 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linuxfoundation.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: add support for gcc 5
Message-ID: <20140904212535.GA5059@drone.musicnaut.iki.fi>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:37:19AM -0400, Sasha Levin wrote:
> We're missing include/linux/compiler-gcc5.h which is required now
> because gcc branched off to v5 in trunk.
> 
> Just copy the relevant bits out of include/linux/compiler-gcc4.h,
> no new code is added as of now.
> 
> This fixes a build error when using gcc 5.

With the new GCC version numbering scheme, does this mean there will
be a new such file to be added every year? Maybe this could be handled
some other way?

A.
