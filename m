Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094AbaGAWJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:09:16 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34142 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaGAWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:09:15 -0400
Date: Tue, 1 Jul 2014 15:09:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Davidlohr Bueso <davidlohr@hp.com>
cc: akpm@linux-foundation.org, aswin@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm,hugetlb: make unmap_ref_private() return void
In-Reply-To: <1404246097-18810-1-git-send-email-davidlohr@hp.com>
Message-ID: <alpine.DEB.2.02.1407011508570.4004@chino.kir.corp.google.com>
References: <1404246097-18810-1-git-send-email-davidlohr@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Davidlohr Bueso wrote:

> This function always returns 1, thus no need to check return value
> in hugetlb_cow(). By doing so, we can get rid of the unnecessary WARN_ON
> call. While this logic perhaps existed as a way of identifying future
> unmap_ref_private() mishandling, reality is it serves no apparent purpose.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: David Rientjes <rientjes@google.com>
