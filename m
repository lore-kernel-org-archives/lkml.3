Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab3FRQai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:30:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933184Ab3FRQag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:30:36 -0400
Message-ID: <51C08B01.40200@zytor.com>
Date: Tue, 18 Jun 2013 11:29:53 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] x86, mtrr: fixs for mtrr_cleanup
References: <1371154622-8929-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1371154622-8929-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 03:17 PM, Yinghai Lu wrote:
> Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
> during add range) broke mtrr cleanup on his setup in 3.9.5.
> corresponding commit in upstream is fbe06b7bae7c.
> 
>   *BAD*gran_size: 64K chunk_size: 16M num_reg: 6 lose cover RAM: -0G
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=59491
> 
> Fix it from two places, so late mtrr cleanup side and range add side.
> 
>   x86, mtrr: Fix original mtrr range get for mtrr_cleanup
>   range: Do not add new blank slot with add_range_with_merge
> 
> Please apply them for v3.10.
> 

On this subject: what do we need to happen to be able to dump the MTRR
cleanup stuff?

	-hpa


