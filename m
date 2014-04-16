Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaDPQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:52:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33646 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaDPQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:52:37 -0400
Message-ID: <534EB55B.60107@kernel.dk>
Date: Wed, 16 Apr 2014 10:52:43 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] blk-mq: bidi support
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-3-git-send-email-hch@lst.de> <534EB2BA.7020705@kernel.dk> <20140416164406.GA19850@lst.de> <534EB38F.7050801@kernel.dk> <20140416164739.GA19947@lst.de>
In-Reply-To: <20140416164739.GA19947@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 10:47 AM, Christoph Hellwig wrote:
> On Wed, Apr 16, 2014 at 10:45:03AM -0600, Jens Axboe wrote:
>> There's nothing wrong with the check, it's identical to one I sent out
>> last week. But it's not part of the bidi enable patch, it's a separate
>> bug fix for bsg.
> 
> Do you want to split it up while applying or should I resend two
> separate patches?

I cut that part and applied, whole series is applied now.

-- 
Jens Axboe

