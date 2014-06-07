Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaFGUMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 16:12:17 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:36650 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbaFGUMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 16:12:16 -0400
Date: Sat, 7 Jun 2014 15:12:13 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] mm/slab.c: add __init to init_lock_keys
In-Reply-To: <1402140626-20914-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.10.1406071511570.8766@gentwo.org>
References: <1402140626-20914-1-git-send-email-fabf@skynet.be>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014, Fabian Frederick wrote:

> init_lock_keys is only called by __init kmem_cache_init_late

Acked-by: Christoph Lameter <cl@linux.com>
