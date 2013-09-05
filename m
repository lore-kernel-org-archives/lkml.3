Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3IEOMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:12:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53445 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3IEOMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:12:17 -0400
Message-ID: <5228913A.50807@kernel.dk>
Date: Thu, 05 Sep 2013 08:12:10 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: OS Engineering <osengineering@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad> <x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com> <26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad> <x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 06:00 AM, Jeff Moyer wrote:
> OS Engineering <osengineering@stec-inc.com> writes:
> 
>> Hi Jeff,
>>
>> Thank you for reviewing the patch.
> 
> No problem.  Jens, any objection to queueing this up for 3.12?

I'll give it a look-over, but usually I'm pretty lax when it comes to
new drivers. So no, I'd be surprised if we can't queue this up for 3.12.

-- 
Jens Axboe

