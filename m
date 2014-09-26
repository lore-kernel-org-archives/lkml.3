Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaIZKUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:20:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38777 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbaIZKUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:20:53 -0400
Message-ID: <54253E02.3080209@suse.cz>
Date: Fri, 26 Sep 2014 12:20:50 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3.12 040/142] s390/locking: Reenable optimistic spinning
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz> <f008331068945523ff12ff13f6d07d7303e0e8a9.1411724723.git.jslaby@suse.cz> <54253AB3.7000307@de.ibm.com>
In-Reply-To: <54253AB3.7000307@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014, 12:06 PM, Christian Borntraeger wrote:
> On 09/26/2014 11:44 AM, Jiri Slaby wrote:
>> From: Christian Borntraeger <borntraeger@de.ibm.com>
>>
>> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> I just checked.
> 
> It seems that the referenced commit 4badad352a6bb202ec68afa7a574c0bb961e5ebc
> (locking/mutex: Disable optimistic spinning on some architectures)
> is not part of 3.12-stable. So this fix is not (yet) necessary.

Hi, thanks for checking. However as far as I can see, 4badad352a6 is in
3.12.26 already, right?

thanks,
-- 
js
suse labs
