Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaBDDRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 22:17:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28173 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaBDDRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 22:17:06 -0500
Message-ID: <52F05B7A.9040209@oracle.com>
Date: Mon, 03 Feb 2014 22:16:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@redhat.com
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 0/2] tools: lockdep: build fixes
References: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
In-Reply-To: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 04:35 PM, Ira W. Snyder wrote:
> From: "Ira W. Snyder" <iws@ovro.caltech.edu>
>
> Included are some fixes to the tools/lib/lockdep source tree to fix some
> build issues.
>
> Ira W. Snyder (2):
>    tools: lockdep: fix include of asm/hash.h
>    tools: lockdep: add include directory to allow tests to compile
>
>   tools/lib/lockdep/Makefile            | 2 +-
>   tools/lib/lockdep/uinclude/asm/hash.h | 6 ++++++
>   2 files changed, 7 insertions(+), 1 deletion(-)
>   create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h
>

	Acked-by: Sasha Levin <sasha.levin@oracle.com>


Ingo, How would you like the liblockdep things to work? Would you be picking them
yourself directly to the locking tree or should I be sending a pull request?


Thanks,
Sasha
