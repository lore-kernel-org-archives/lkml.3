Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaHONl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:41:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:36882 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaHONlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:41:55 -0400
Date: Fri, 15 Aug 2014 10:41:51 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Elliott Hughes <enh@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH] Add arm64 triples to perf.
Message-ID: <20140815134151.GC3508@kernel.org>
References: <20140814193920.A7D2D20572@enh.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814193920.A7D2D20572@enh.mtv.corp.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 14, 2014 at 12:39:20PM -0700, Elliott Hughes escreveu:
> 
> Adds the triple used for arm64 by Android. Others will want to add
> their own later.
> 
> Signed-off-by: Elliott Hughes <enh@google.com>

Thanks, applied.

- Arnaldo
