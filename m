Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab3GWNhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459Ab3GWNhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:37:42 -0400
Message-ID: <51EE8721.10500@suse.cz>
Date: Tue, 23 Jul 2013 15:37:37 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [pull request] Pull request for branch yem-kconfig-rc-fixes
References: <cover.1374006854.git.yann.morin.1998@free.fr> <1374055158.4495.1.camel@chaos.site>
In-Reply-To: <1374055158.4495.1.camel@chaos.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.7.2013 11:59, Jean Delvare wrote:
> Le Tuesday 16 July 2013 à 22:39 +0200, Yann E. MORIN a écrit :
>> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
>>
>> Hello Michal,
>>
>> Please pull these post-rc1 kconfig cleanups, all after
>> review and comments by Jean:
>>   - simplify and cleanup the symbol-search code
>>   - better documentation about the symbols ordering in search results
>>   - eye-candy in the title of the search-box in [mn]conf
>>
>> Regards,
>> Yann E. MORIN.
> 
> It looks very good to me now, thanks Yann for the good work!

It does look good indeed. But I am wondering if it's necessary for 3.11.
AFAICS the only user-visible changes are

  [PATCH 1/6] Documentation/kconfig: more concise and straightforward
search explanation
  [PATCH 3/6] kconfig/[mn]conf: shorten title in search-box

and the rest are code cleanups (however worthwhile), is that correct?
There is no change in the search behavior, is there? Then I would say
merge this for 3.12-rc1. Maybe merge the documentation patch for 3.11.

Thanks,
Michal
