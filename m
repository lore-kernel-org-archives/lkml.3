Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaJHQPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:15:41 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40738 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJHQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:15:40 -0400
Message-ID: <1412784937.11091.185.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: description of dma_cookie cause make xmldocs
 warning
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, dan.j.williams@intel.com
Date: Wed, 08 Oct 2014 09:15:37 -0700
In-Reply-To: <54355F66.6060204@cogentembedded.com>
References: <1412780019-32475-1-git-send-email-standby24x7@gmail.com>
	 <54355F66.6060204@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 19:59 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/08/2014 06:53 PM, Masanari Iida wrote:
> 
> > In commit 7bced397510ab569d31de4c70b39e13355046387,
> 
>     Please also specify that commit's summary line in parens.

Note that this information is useful for backports and bug fixes.

In this particular case (documentation), there is no chance we'll
backport this patch to any prior stable kernel


