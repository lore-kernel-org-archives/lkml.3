Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaBCGRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:17:31 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47978 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaBCGRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:17:30 -0500
Date: Sun, 2 Feb 2014 22:17:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] mm: vmscan: shrink_slab: rename max_pass ->
 freeable
In-Reply-To: <1391361090-526-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.02.1402022217100.10847@chino.kir.corp.google.com>
References: <1391361090-526-1-git-send-email-vdavydov@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Feb 2014, Vladimir Davydov wrote:

> The name `max_pass' is misleading, because this variable actually keeps
> the estimate number of freeable objects, not the maximal number of
> objects we can scan in this pass, which can be twice that. Rename it to
> reflect its actual meaning.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: David Rientjes <rientjes@google.com>
