Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKYHEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:04:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaKYHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:04:40 -0500
Date: Mon, 24 Nov 2014 23:05:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        HyoJun Im <hyojun.im@lge.com>, Gunho Lee <gunho.lee@lge.com>,
        Wonhong Kwon <wonhong.kwon@lge.com>
Subject: Re: [PATCH] mm: add parameter to disable faultaround
Message-Id: <20141124230502.30f9b6f0.akpm@linux-foundation.org>
In-Reply-To: <1416898318-17409-1-git-send-email-chanho.min@lge.com>
References: <1416898318-17409-1-git-send-email-chanho.min@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 15:51:58 +0900 Chanho Min <chanho.min@lge.com> wrote:

> The faultaround improves the file read performance, whereas pages which
> can be dropped by drop_caches are reduced. On some systems, The amount of
> freeable pages under memory pressure is more important than read
> performance.

The faultaround pages *are* freeable.  Perhaps you meant "free" here.

Please tell us a great deal about the problem which you are trying to
solve.  What sort of system, what sort of workload, what is bad about
the behaviour which you are observing, etc.


