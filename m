Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3GDJHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:07:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab3GDJHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:07:08 -0400
Message-ID: <51D53B38.7040202@suse.cz>
Date: Thu, 04 Jul 2013 11:07:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Daniel Tang <dt.tangr@gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the kbuild tree
References: <20130704143353.e695ca64b17705c842676870@canb.auug.org.au> <20130703214300.11d9223a.akpm@linux-foundation.org>
In-Reply-To: <20130703214300.11d9223a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.7.2013 06:43, Andrew Morton wrote:
> On Thu, 4 Jul 2013 14:33:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Andrew,
>>
>> Today's linux-next merge of the akpm tree got conflicts in
>> tools/include/tools/be_byteshift.h and tools/include/tools/le_byteshift.h
>> between commit b35310627f39 ("tools/include: use stdint types for
>> user-space byteshift headers") from the kbuild tree and commit
>> "scripts/sortextable.c: fix building on non-Linux systems" from the
>> akpm tree.
>>
>> As fas as I can tell, these patches do the same thing except one uses
>> stdint.h and the other inttypes.h.  I just dropped the akpm tree patch.
> 
> Well OK, but new patches really shouldn't be popping up in the middle
> of the merge window like this.

Sorry for that.


> AFAICT Yaakov (re)sent this patch way back in April, so it should have
> been in -next for a long time.  Something has gone wrong here.

I only saw an email from June 26, I wasn't on the CC list of the
previous submissions.

Michal
