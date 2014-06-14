Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaFNHk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:40:56 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4353 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbaFNHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:40:55 -0400
X-IronPort-AV: E=Sophos;i="5.01,476,1400018400"; 
   d="scan'208";a="67150544"
Date: Sat, 14 Jun 2014 09:40:52 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>, benoit.taine@lip6.fr
Subject: Re: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of
 memory' messages
In-Reply-To: <1402502500.6169.5.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1406140937370.2003@localhost6.localdomain6>
References: <1402419340.30479.18.camel@joe-AO725>  <20140611074704.GS5015@mwanda> <1402502500.6169.5.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a semantic patch that searches for the various calls and then a 
string containing the letters "emory", I get removals of the messages 
below.  Do any of these messages look useful?  For example, some are 
generated with specific functions, such as IRDA_ERROR or BT_ERR.  If none 
of the messages look useful, should just one big patch go to trivial, or 
should the patches go to the individual maintainers?

julia
