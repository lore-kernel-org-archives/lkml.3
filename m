Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3FYCA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:00:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3FYCA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:00:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,932,1363104000"; 
   d="scan'208";a="7668004"
Message-ID: <51C8F427.4010601@cn.fujitsu.com>
Date: Tue, 25 Jun 2013 09:36:39 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: bp@alien8.de, pablo@netfilter.org, kaber@trash.net,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: v3.10-rc7 oops soon after boot
References: <20130624221708.15489.qmail@science.horizon.com>
In-Reply-To: <20130624221708.15489.qmail@science.horizon.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/25 09:33:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/25 09:33:57,
	Serialize complete at 2013/06/25 09:33:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 06:17 AM, George Spelvin wrote:
>>> Reported-by: Borislav Petkov <bp@alien8.de>
> 
>> This should be:
>>
>> Reported-by: George Spelvin <linux@horizon.com>
>>
>> I only connected the dots...
> 
> Well, you did a whole lot more than me!  I just lobbed a "d'oh, it
> crashes" into the seething ocean of lkml.  (Admittedly, I had reason
> to act fast: we're very close to release.)
> 
> You figured out what subsystem was at fault and got the right people
> involved.  Definitely a valuable contribution.
> 
> Me, personally, I don't give a flying f*** about such credit; I had
> an itch and was trolling for someone to scratch it.
> 
> So feel free to take Reported-by (you are the one who reported it *to
> someone who could fix it*), Triaged-by, or whatever.

It's my mistake, the reported-by should be you.
of course we should thank Borislav, I didn't notice this bug report
mail until he forwarded it.

Thanks all you guys! Sorry for my mistake..

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

