Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaIAMrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:47:21 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:34373 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaIAMrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:47:20 -0400
Message-ID: <54046ACE.2080701@codethink.co.uk>
Date: Mon, 01 Sep 2014 13:47:10 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jbaron@akamai.com,
        cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@codethink.co.uk
Subject: Re: [PATCH 0/4] Tidy up of modules using seq_open()
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk> <20140829121426.4044f2a330f9d74fe37f7825@linux-foundation.org>
In-Reply-To: <20140829121426.4044f2a330f9d74fe37f7825@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 20:14, Andrew Morton wrote:
> On Fri, 29 Aug 2014 17:06:36 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
>
>> Many modules use seq_open() when seq_open_private() or
>> __seq_open_private() would be more appropriate and result in
>> simpler, cleaner code.
>>
>> This patch sequence changes those instances in IPC, MM and LIB.
>
> Looks good to me.
>
> I can't begin to imagine why we added the global, exported-to-modules
> seq_open_private() without bothering to document it, so any time you
> feel like adding the missing kerneldoc...

Already done, I waited for that to be accepted before I submitted this
patch :-)

>
> And psize should have been size_t, ho hum.

I'll fix that while I'm in the vicinity.

>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
