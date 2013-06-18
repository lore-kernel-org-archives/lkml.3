Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab3FRUUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:20:46 -0400
Received: from longford.logfs.org ([213.229.74.203]:59575 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab3FRUUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:20:45 -0400
Date: Tue, 18 Jun 2013 14:50:55 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] hugetlb fixes
Message-ID: <20130618185055.GA27618@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371581225-27535-1-git-send-email-joern@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 June 2013 14:47:03 -0400, Joern Engel wrote:
> 
> Test program below is failing before these two patches and passing
> after.

Actually, do we have a place to stuff kernel tests?  And if not,
should we have one?

Jörn

--
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra
