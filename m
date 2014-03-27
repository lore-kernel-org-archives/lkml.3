Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaC0Ai6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:38:58 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:42739
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533AbaC0Ai5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:38:57 -0400
Date: Wed, 26 Mar 2014 19:38:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mitchel Humpherys <mitchelh@codeaurora.org>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: convert some level-less printks to pr_*
In-Reply-To: <1395877783-18910-2-git-send-email-mitchelh@codeaurora.org>
Message-ID: <alpine.DEB.2.10.1403261938160.5585@nuc>
References: <1395877783-18910-1-git-send-email-mitchelh@codeaurora.org> <1395877783-18910-2-git-send-email-mitchelh@codeaurora.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, Mitchel Humpherys wrote:

> printk is meant to be used with an associated log level. There are some
> instances of printk scattered around the mm code where the log level is
> missing. Add a log level and adhere to suggestions by
> scripts/checkpatch.pl by moving to the pr_* macros.

Acked-by: Christoph Lameter <cl@linux.com>

