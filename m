Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaBZTkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:40:40 -0500
Received: from mailout.micron.com ([137.201.242.129]:24063 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaBZTkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:40:39 -0500
Message-ID: <530E4316.3030708@micron.com>
Date: Wed, 26 Feb 2014 11:40:06 -0800
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Thunderbird/27.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: mtip32xx blk-mq status?
References: <20140226192945.GA26603@infradead.org>
In-Reply-To: <20140226192945.GA26603@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20534.000
X-TM-AS-Result: No--2.086700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/2014 11:29 AM, Christoph Hellwig wrote:
> Hi all,
> 
> with blk-mq stabilizing in mainline and Jens using mtip32xx as tje major
> example drivers in the past is there any progress on getting the
> conversion finished and merged?

We are working on few changes in mtip32xx. After that, we will get to
blk-mq merge.

--
Regards,
Asai
