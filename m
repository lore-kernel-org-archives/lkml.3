Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaHWPiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:38:12 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:47097
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaHWPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:38:10 -0400
Date: Sat, 23 Aug 2014 10:38:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/15] percpu: fix pcpu_alloc_pages() failure path
In-Reply-To: <1408726399-4436-2-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.11.1408231037030.29970@gentwo.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org> <1408726399-4436-2-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Tejun Heo wrote:

> Fix it by open-coding the partial freeing of the already allocated
> pages.

Acked-by: Christoph Lameter <cl@linux.com>
