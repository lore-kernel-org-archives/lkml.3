Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaANTbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:31:16 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:35431 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbaANTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:31:12 -0500
Date: Tue, 14 Jan 2014 13:31:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 1/9] mm: slab/slub: use page->list consistently
 instead of page->lru
In-Reply-To: <20140114180044.1E401C47@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1401141330440.19618@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180044.1E401C47@viggo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> This patch makes the slab and slub code use page->lru
> universally instead of mixing ->list and ->lru.

Acked-by: Christoph Lameter <cl@linux.com>
