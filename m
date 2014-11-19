Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaKSPcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:32:06 -0500
Received: from one.firstfloor.org ([193.170.194.197]:53415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaKSPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:31:52 -0500
Date: Wed, 19 Nov 2014 16:31:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141119153150.GI12538@two.firstfloor.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <20141118133721.GA3790@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118133721.GA3790@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I'm getting compile error for DEBUG=1
> 
> > looks like the BUILD_BUG_ON_MSG does not work correctly with -O6 we use
> 
> Yeah, I'll probably just take the brute force approach Andi originally
> used and switch to BUILD_BUG_ON_MSG once we get it working in the tools/
> environment, i.e. using -O6, etc.

For new enough gcc you could use _Static_assert()

-Andi
