Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaLOPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:00:08 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:43050 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaLOPAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:00:03 -0500
Date: Mon, 15 Dec 2014 14:59:36 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, bp@alien8.de, computersforpeace@gmail.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/4] Documentation: Add cutoff periods for patch
 acceptance
Message-ID: <20141215145936.63d69713@lxorguk.ukuu.org.uk>
In-Reply-To: <1418623790-28429-4-git-send-email-cernekee@gmail.com>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
	<1418623790-28429-4-git-send-email-cernekee@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +  kernel.org "mainline:"  |  Patch may appear
> +  field when posted       |  in released kernel
> +  ------------------------+--------------------------------
> +  3.18-rc[1-4]            |  3.19
> +  3.18-rc[5-9]            |  3.20
> +  3.18                    |  Merge window open - don't post
> +  3.19-rc[1-4]            |  3.20
> +  3.19-rc[5-9]            |  3.21
> +  3.19                    |  Merge window open - don't post
> +
> +Bug fixes can typically be accepted at any time.

That's exactly what was needed I think

Acked-by: Alan Cox <alan@linux.intel.com>

