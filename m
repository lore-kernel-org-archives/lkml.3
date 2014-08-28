Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbaH1M36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:29:58 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:22981
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbaH1M34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:29:56 -0400
X-IronPort-AV: E=Sophos;i="5.04,418,1406584800"; 
   d="scan'208";a="76968711"
Date: Thu, 28 Aug 2014 14:29:51 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH] staging: lustre: mdc: expand the GOTO macro
In-Reply-To: <20140828122641.GM5046@mwanda>
Message-ID: <alpine.DEB.2.10.1408281427590.4009@hadrien>
References: <1409220635-13453-1-git-send-email-Julia.Lawall@lip6.fr> <20140828122641.GM5046@mwanda>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2014, Dan Carpenter wrote:

> Thanks.  These are nice.  We need to get rid of the GOTO() macro
> entirely.

I will.  The whole patch is 11,000 lines (including the context code, @@s
etc), and I didn't have the patience to check all of that at once...

julia
