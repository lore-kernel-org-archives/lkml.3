Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaF0F3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:29:46 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18906
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbaF0F3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:29:44 -0400
X-IronPort-AV: E=Sophos;i="5.01,558,1400018400"; 
   d="scan'208";a="69128205"
Date: Fri, 27 Jun 2014 07:29:39 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Drop cast
In-Reply-To: <1403804286.7977.58.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6>
References: <20140626172852.GA2878@himangi-Dell> <1403804286.7977.58.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jun 2014, Joe Perches wrote:

> On Thu, 2014-06-26 at 22:58 +0530, Himangi Saraogi wrote:
> > This patch removes the cast on data of type void* as it is not needed.
> 
> Hi Himangi
> 
> The cast of a const void * to a void * was odd.
> 
> Maybe a mechanism to verify appropriateness of
> loss of constness for any pointer might be useful.

I tried the following, but didn't find anything interesting:

@disable drop_cast@
type T;
const T e;
@@

* (T)e

julia
