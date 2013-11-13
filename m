Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab3KMXLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:11:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39220 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab3KMXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:10:54 -0500
Message-ID: <528406DB.7070605@ti.com>
Date: Wed, 13 Nov 2013 18:10:19 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/24] mm/block: remove unnecessary inclusion of bootmem.h
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com> <1383954120-24368-5-git-send-email-santosh.shilimkar@ti.com> <20131113020918.GA25143@kernel.dk>
In-Reply-To: <20131113020918.GA25143@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 November 2013 09:09 PM, Jens Axboe wrote:
> On Fri, Nov 08 2013, Santosh Shilimkar wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Clean-up to remove depedency with bootmem headers.
> 
> Thanks, cleaned up for after merge window inclusion. Changed the wording
> to make it more correct and fixed the spelling error:
> 
> block: cleanup removing dependency on bootmem headers
> 
Thanks !!

regards,
Santosh
