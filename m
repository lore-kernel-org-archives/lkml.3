Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3AOPgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:36:39 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:24611 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713Ab3AOPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:36:38 -0500
Date: Tue, 15 Jan 2013 15:36:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] slub: add 'likely' macro to inc_slabs_node()
In-Reply-To: <1358234402-2615-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013c3edaddec-dc190a12-1fc1-4a9e-aa19-dd74c374c499-000000@email.amazonses.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com> <1358234402-2615-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Joonsoo Kim wrote:

> After boot phase, 'n' always exist.
> So add 'likely' macro for helping compiler.

Acked-by: Christoph Lameter <cl@linux.com>
