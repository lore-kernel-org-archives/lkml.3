Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaGKQay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:30:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34562 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbaGKQax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:30:53 -0400
Message-ID: <53C0112C.1000707@zytor.com>
Date: Fri, 11 Jul 2014 09:30:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>
CC: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32
 filter
References: <cover.1405023592.git.rgb@redhat.com> <1458762.ra4TnS54ZN@sifl>	 <1405095407.2357.1.camel@flatline.rdu.redhat.com>	 <14055169.hesOIjNJgN@sifl> <1405095813.2357.3.camel@flatline.rdu.redhat.com>
In-Reply-To: <1405095813.2357.3.camel@flatline.rdu.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 09:23 AM, Eric Paris wrote:
>>
>> You're not going to hear me ever say that I like how the x32 ABI was done, it 
>> is a real mess from a seccomp filter point of view and we have to do some 
>> nasty stuff in libseccomp to make it all work correctly (see my comments on 
>> the libseccomp-devel list regarding my severe displeasure over x32), but 
>> what's done is done.
>>
>> I think it's too late to change the x32 seccomp filter ABI.
> 
> So we have a security interface that is damn near impossible to get
> right.  Perfect.
> 
> I think this explains exactly why I support this idea.  Make X32 look
> like everyone else and put these custom horrific hacks in seccomp if we
> are unwilling to 'do it right'
> 
> Honestly, how many people are using seccomp on X32 and would be horribly
> pissed if we just fixed it?
> 

The bigger issue is probably if we will open a problem with the older
kernels.

	-hpa

