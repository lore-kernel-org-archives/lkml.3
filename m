Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3GWOhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:37:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab3GWOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:37:03 -0400
Message-ID: <51EE94EF.1010705@suse.cz>
Date: Tue, 23 Jul 2013 16:36:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [pull request] Pull request for branch yem-kconfig-rc-fixes
References: <cover.1374006854.git.yann.morin.1998@free.fr> <1374055158.4495.1.camel@chaos.site> <51EE8721.10500@suse.cz> <201307231555.00241.yann.morin.1998@free.fr>
In-Reply-To: <201307231555.00241.yann.morin.1998@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yann E. MORIN wrote:
> Michal, All,
> 
> On Tuesday 23 July 2013 15:37:37 Michal Marek wrote:
>> It does look good indeed. But I am wondering if it's necessary for 3.11.
>> AFAICS the only user-visible changes are
>>
>>   [PATCH 1/6] Documentation/kconfig: more concise and straightforward
>> search explanation
>>   [PATCH 3/6] kconfig/[mn]conf: shorten title in search-box
>>
>> and the rest are code cleanups (however worthwhile), is that correct?
>> There is no change in the search behavior, is there? Then I would say
>> merge this for 3.12-rc1. Maybe merge the documentation patch for 3.11.
> 
> I think you can merge all for 3.12-rc1, in fact.
> Even patches 1 and 3 are only eye-candy, and can well wait for 3.12.

OK, I merged it to kbuild.git#kconfig then. It will show up a bit later
on git.kernel.org, as I forgot my laptop with the ssh key at home :).

Michal
