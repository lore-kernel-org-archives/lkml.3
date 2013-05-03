Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab3ECPTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:19:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3ECPTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:19:38 -0400
Message-ID: <5183D585.5040508@suse.cz>
Date: Fri, 03 May 2013 17:19:33 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/2] deb-pkg: split debug symbols in their own package
References: <1363946761-7449-1-git-send-email-anisse@astier.eu> <51629BFF.1080204@suse.cz> <20130408190645.29570fe5@serenity> <20130409120547.64ad0d50@serenity> <20130419100519.485cb557@serenity> <20130503170823.3991bb0f@serenity>
In-Reply-To: <20130503170823.3991bb0f@serenity>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.5.2013 17:08, Anisse Astier wrote:
> On Fri, 19 Apr 2013 10:05:19 +0200, Anisse Astier <anisse@astier.eu> wrote :
> 
>> On Tue, 9 Apr 2013 12:05:47 +0200, Anisse Astier <anisse@astier.eu> wrote :
>>
>>>
>>>
>>> From: Anisse Astier <anisse@astier.eu>
>>> Subject: [PATCH v3] deb-pkg: split debug symbols in their own package
>>>
>>> This can reduce almost 3 times the size of the linux-image package,
>>> while keeping the debug symbols available for this particular build, in
>>> their own package.
>>>
>>> This mimics the way kernels are built in debian, ubuntu, or with
>>> make-kpkg, and comes at the price of a small slowdown in the building of
>>> packages.
>>>
>>> v2:
>>>  - only build when CONFIG_DEBUG_INFO=y
>>>  - build debug package last.
>>>  - more verbose package description
>>>  - put package in section debug
>>> v3:
>>>  - remove duplicate code from v2
>>>
>>
>> What do you think ?
> 
> Any update ?

I don't know much about debian (kernel) packaging, so I'd like to hear
Max's opinion before merging this.

Michal
