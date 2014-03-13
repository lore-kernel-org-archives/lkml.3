Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaCMPa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:30:57 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51400 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaCMPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:30:56 -0400
Message-ID: <5321CF2B.6090309@kernel.dk>
Date: Thu, 13 Mar 2014 09:30:51 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Felipe Franciosi <felipe@paradoxo.org>, linux-kernel@vger.kernel.org
CC: Sam Bradshaw <sbradshaw@micron.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 2/2] mtip32xx: Unmap the DMA segments before completing
 the IO request
References: <1394721261-2764-1-git-send-email-felipe@paradoxo.org> <1394721261-2764-3-git-send-email-felipe@paradoxo.org>
In-Reply-To: <1394721261-2764-3-git-send-email-felipe@paradoxo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 08:34 AM, Felipe Franciosi wrote:
> If the buffers are unmapped after completing a request, then stale data
> might be in the request.

Both should be marked for stable, I'll add that.

Sam, I'll queue these two up. Please re-send your fix for bug introduced 
with the unaligned reduction as a proper patch, and I'll get that in too.

-- 
Jens Axboe

