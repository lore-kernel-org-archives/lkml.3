Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaAZJKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:10:51 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60609 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaAZJKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:10:40 -0500
Date: Sun, 26 Jan 2014 10:10:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mm: Avoid extra pxm_to_node()
Message-ID: <20140126091036.GA31263@gmail.com>
References: <20140126084604.GA30853@gmail.com>
 <1390727415-26376-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390727415-26376-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> In slit init code, more pxm_to_node() calling are added.
> 
> We can cache return with from_node/to_node to avoid them.

-ENOPARSE. Please formulate the title and the changelog in an 
understandable form.

Thanks,

	Ingo
