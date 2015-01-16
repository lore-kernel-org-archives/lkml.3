Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbbAPOba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:31:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbbAPOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:31:29 -0500
Message-ID: <54B920BB.3010205@oracle.com>
Date: Fri, 16 Jan 2015 09:31:23 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
References: <54B4A909.9060206@oracle.com>	<20150113164441.5b210f48@tlielax.poochiereds.net>	<54B5A145.6060108@oracle.com>	<20150114092705.39bd4881@tlielax.poochiereds.net>	<54B6FF69.3080705@oracle.com> <20150115152247.5e660000@tlielax.poochiereds.net>
In-Reply-To: <20150115152247.5e660000@tlielax.poochiereds.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 03:22 PM, Jeff Layton wrote:
> Ok, I tried to reproduce it with that and several variations but it
> still doesn't seem to do it for me. Can you try the latest linux-next
> tree and see if it's still reproducible there?

It's still not in in today's -next, could you send me a patch for testing
instead?


Thanks,
Sasha
