Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaHNJhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:37:51 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:64103 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaHNJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:37:49 -0400
Message-ID: <53EC8369.8030406@colorfullife.com>
Date: Thu, 14 Aug 2014 11:37:45 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, Joe Perches <joe@perches.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] ipc: always handle a new value of auto_msgmni
References: <1407936117-2985-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1407936117-2985-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On 08/13/2014 03:21 PM, Andrey Vagin wrote:
> proc_dointvec_minmax() returns zero, if a new value has been set.
> So we don't need to check all charectes have been handled.
What do you use auto_msgmni for?

I would propose to remove the whole logic - just always allow 32000 
message queues.

--
     Manfred
