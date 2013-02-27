Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3B0Ww7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:52:59 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21408 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B0Ww5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:52:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,751,1355126400"; 
   d="scan'208";a="26881918"
Message-ID: <512E8E48.8020007@codeaurora.org>
Date: Wed, 27 Feb 2013 14:52:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECK
References: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org> <201302272032.21014.arnd@arndb.de> <512E6FA9.4060504@codeaurora.org> <512E8664.3070903@zytor.com>
In-Reply-To: <512E8664.3070903@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/13 14:19, H. Peter Anvin wrote:
> On 02/27/2013 12:42 PM, Stephen Boyd wrote:
>>> It's fine to do your patch as a first step though, which would not
>>> change the behavior.
>> A lot of arches seem to not want to enable it because false positives
>> are everywhere. It really depends on how good the compiler is at doing
>> constant propagation and dead code removal.
>>
> Although some of the cases I have seen being flagged as "false
> positives" have been real bugs.

There were so many false-positives on x86_64 that Andrew eventually
dropped my patch to add support for this option to the copy_from_user()
function there.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

