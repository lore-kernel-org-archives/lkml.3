Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHSIGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:06:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaHSIGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:06:07 -0400
Message-ID: <53F3056C.7040705@suse.cz>
Date: Tue, 19 Aug 2014 10:06:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation: kbuild: Improve grammar
References: <1407511390-5429-1-git-send-email-geert@linux-m68k.org> <1407511390-5429-4-git-send-email-geert@linux-m68k.org> <53EA48F2.6060003@infradead.org> <53EB4F39.6030501@suse.cz>
In-Reply-To: <53EB4F39.6030501@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-13 13:42, Michal Marek wrote:
> On 2014-08-12 19:03, Randy Dunlap wrote:
>> On 08/08/14 08:23, Geert Uytterhoeven wrote:
>>>   - singular versus plural,
>>>   - "by" versus "of",
>>>   - missing "if", "it", "the",
>>>   - consistent use of "xxx-specific" versus "xxx specific".
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> ---
>>>  Documentation/kbuild/makefiles.txt | 58 +++++++++++++++++++-------------------
>>>  1 file changed, 29 insertions(+), 29 deletions(-)
>>
>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>>
>> Michal, are you going to pick up Geert's 4 kbuild doc. patches
>> or should I do it?
> 
> I can do it. I'm just waiting for Linus to merge what is currently in
> the kbuild branches, before pushing anything else.

Applied to kbuild.git#misc now.

Thanks,
Michal

