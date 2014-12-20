Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaLTAR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:17:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLTAR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:17:58 -0500
Date: Fri, 19 Dec 2014 16:17:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>, ngupta@vflare.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/zsmalloc: add statistics support
Message-Id: <20141219161756.bcf7421acb4bc7a286c1afa3@linux-foundation.org>
In-Reply-To: <20141220001043.GC11975@blaptop>
References: <1418993719-14291-1-git-send-email-opensource.ganesh@gmail.com>
	<20141219143244.1e5fabad8b6733204486f5bc@linux-foundation.org>
	<20141219233937.GA11975@blaptop>
	<20141219154548.3aa4cc02b3322f926aa4c1d6@linux-foundation.org>
	<20141219235852.GB11975@blaptop>
	<20141219160648.5cea8a6b0c764caa6100a585@linux-foundation.org>
	<20141220001043.GC11975@blaptop>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014 09:10:43 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > It involves rehashing a lengthy argument with Greg.
> 
> Okay. Then, Ganesh,
> please add warn message about duplicaed name possibility althoug
> it's unlikely as it is.

Oh, getting EEXIST is easy with this patch.  Just create and destroy a
pool 2^32 times and the counter wraps ;) It's hardly a serious issue
for a debugging patch.
