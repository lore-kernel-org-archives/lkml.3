Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaH2QYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:24:48 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:37485 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbaH2QYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:24:47 -0400
Date: Fri, 29 Aug 2014 11:24:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Rob Jones <rob.jones@codethink.co.uk>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jbaron@akamai.com,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        linux-kernel@codethink.co.uk
Subject: Re: [PATCH 3/4] mm: Use __seq_open_private() instead of seq_open()
In-Reply-To: <1409328400-18212-4-git-send-email-rob.jones@codethink.co.uk>
Message-ID: <alpine.DEB.2.11.1408291124290.23612@gentwo.org>
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk> <1409328400-18212-4-git-send-email-rob.jones@codethink.co.uk>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014, Rob Jones wrote:

> Using __seq_open_private() removes boilerplate code from slabstats_open()

Acked-by: Christoph Lameter <cl@linux.com>

