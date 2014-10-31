Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbaJaObM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:31:12 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50813 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaJaObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:31:10 -0400
Message-ID: <54539D2B.3000302@kernel.dk>
Date: Fri, 31 Oct 2014 08:31:07 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] block: Fix computation of merged request priority
References: <1414698218-11199-1-git-send-email-jack@suse.cz>
In-Reply-To: <1414698218-11199-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-30 13:43, Jan Kara wrote:
> Priority of a merged request is computed by ioprio_best(). If one of the
> requests has undefined priority (IOPRIO_CLASS_NONE) and another request
> has priority from IOPRIO_CLASS_BE, the function will return the
> undefined priority which is wrong. Fix the function to properly return
> priority of a request with the defined priority.

Thanks Jan, applied. I fixed up a indentation issue, jfyi.

-- 
Jens Axboe

