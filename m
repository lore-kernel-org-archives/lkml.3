Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3KAPDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:03:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53366 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3KAPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:03:30 -0400
Message-ID: <5273C2B8.5030608@kernel.dk>
Date: Fri, 01 Nov 2013 09:03:20 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH for-next] dm: fix missing bi_remaining accounting
References: <20131101135931.GA22903@redhat.com>
In-Reply-To: <20131101135931.GA22903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 07:59 AM, Mike Snitzer wrote:
> Add the missing bi_remaining increment, required by the block layer's
> new bio-chaining code, to both the verity and old snapshot DM targets.
> 
> Otherwise users will hit the bi_remaining <= 0 BUG_ON in bio_endio().

Thanks Mike, added to the mix.

-- 
Jens Axboe

