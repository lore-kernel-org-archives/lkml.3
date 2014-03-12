Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaCLQQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:16:32 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:65244 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaCLQQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:16:28 -0400
Message-ID: <5320885B.50507@kernel.dk>
Date: Wed, 12 Mar 2014 10:16:27 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Felipe Franciosi <felipe@paradoxo.org>, linux-kernel@vger.kernel.org
CC: Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/2] mtip32xx: Unmap the DMA segments before completing
 the IO request
References: <1394640348-9109-1-git-send-email-felipe@paradoxo.org> <1394640348-9109-3-git-send-email-felipe@paradoxo.org>
In-Reply-To: <1394640348-9109-3-git-send-email-felipe@paradoxo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 10:05 AM, Felipe Franciosi wrote:
> If the buffers are unmapped after completing a request, then stale data
> might be in the request.

This is unfortunate, and a real bug. Good catch!

-- 
Jens Axboe

