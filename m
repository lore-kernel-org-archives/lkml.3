Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab3A1XI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:08:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3A1XI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:08:56 -0500
Date: Mon, 28 Jan 2013 15:08:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/11] ksm: allow trees per NUMA node
Message-Id: <20130128150854.6813b1ca.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1301251753380.29196@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
	<alpine.LNX.2.00.1301251753380.29196@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 17:54:53 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> +/* Zeroed when merging across nodes is not allowed */
> +static unsigned int ksm_merge_across_nodes = 1;

I spose this should be __read_mostly.  If __read_mostly is not really a
synonym for __make_write_often_storage_slower.  I continue to harbor
fear, uncertainty and doubt about this...


