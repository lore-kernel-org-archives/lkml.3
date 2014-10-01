Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaJAOSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:18:45 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56412 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaJAOSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:18:44 -0400
Message-ID: <542C0D40.6080504@kernel.dk>
Date: Wed, 01 Oct 2014 08:18:40 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: misplaced rq_complete tracepoint
References: <1412166751-73709-1-git-send-email-hare@suse.de>
In-Reply-To: <1412166751-73709-1-git-send-email-hare@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-01 06:32, Hannes Reinecke wrote:
> The rq_complete tracepoint was never issued for empty requests,
> causing the resulting blktrace information to never show any
> completion for those request.

Thanks Hannes, applied.

-- 
Jens Axboe

