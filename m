Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3BTHBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:01:21 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:35763 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3BTHBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:01:19 -0500
Date: Tue, 19 Feb 2013 23:01:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Miller <davem@davemloft.net>
cc: mroos@ut.ee, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH 1/3] sparc64: Fix gfp_flags setting in tsb_grow().
In-Reply-To: <20130220.014152.1773146557292897449.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1302192301040.27407@chino.kir.corp.google.com>
References: <20130220.014152.1773146557292897449.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, David Miller wrote:

> 
> We should "|= more_flags" rather than "= more_flags".
> 
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: David Rientjes <rientjes@google.com>
