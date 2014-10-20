Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaJTWBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:01:45 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39111 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaJTWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:01:43 -0400
Message-ID: <54458644.5000404@kernel.dk>
Date: Mon, 20 Oct 2014 16:01:40 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: relliott@beardog.cce.hp.com, Robert Elliott <elliott@hp.com>
CC: webbnh@hp.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, scameron@beardog.cce.hp.com
Subject: Re: [PATCH 0/2] fs: merge I/O error prints into one line
References: <20140827155036.32144.56190.stgit@beardog.cce.hp.com> <20141020214302.GB3467@beardog.cce.hp.com> <544585FE.7080604@kernel.dk>
In-Reply-To: <544585FE.7080604@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 04:00 PM, Jens Axboe wrote:
> On 10/20/2014 03:43 PM, relliott@beardog.cce.hp.com wrote:
>> On Wed, Aug 27, 2014 at 10:51:54AM -0500, Robert Elliott wrote:
>>> The following series merges I/O error prints into one
>>> line and makes rate limited messages clearer.
>>>
>>> ---
>>>
>>> Robert Elliott (2):
>>>       fs: merge I/O error prints into one line
>>>       fs: clarify rate limit suppressed buffer I/O errors
>>>
>>>
>>>  fs/buffer.c |   38 +++++++++-----------------------------
>>>  1 files changed, 9 insertions(+), 29 deletions(-)
>>>
>>> -- 
>>> Rob Elliott, HP Server Storage  elliott@hp.com
>>
>> ping
> 
> Both are in 3.18-rc1, as released yesterday.

Ugh no, I mixed these up with the other two (related) patches. I'll add
these for a later pull this cycle.


-- 
Jens Axboe

