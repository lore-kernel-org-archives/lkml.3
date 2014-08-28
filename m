Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaH1X3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:29:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1X3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:29:03 -0400
Message-ID: <53FFBB3C.8010207@infradead.org>
Date: Thu, 28 Aug 2014 16:29:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rob Jones <rob.jones@codethink.co.uk>,
        Steven Whitehouse <swhiteho@redhat.com>, linux-fsdevel@vger.kernel.org
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk, viro@ZenIV.linux.org.uk,
        ebiederm@xmission.com, ian.molton@codethink.co.uk
Subject: Re: [PATCH V3] seq_file: Document seq_open_private(), seq_release_private()
References: <1408362005-21504-1-git-send-email-rob.jones@codethink.co.uk> <53F1E879.2050302@redhat.com> <53FC6872.3060800@codethink.co.uk>
In-Reply-To: <53FC6872.3060800@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/14 03:58, Rob Jones wrote:
> Are there any other responses on this please? It seems pretty
> uncontentious. Maybe everyone was at LinuxCon last week.
> 
> On 18/08/14 12:50, Steven Whitehouse wrote:
>> Hi,
>>
>> On 18/08/14 12:40, Rob Jones wrote:
>>> Despite the fact that these functions have been around for years, they
>>> are
>>> little used (only 15 uses in 13 files at the preseht time) even though
>>> many other files use work-arounds to achieve the same result.
>>>
>>> By documenting them, hopefully they will become more widely used.
>>>
>>> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
>> Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Applied.  Thanks.

-- 
~Randy
