Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750957AbaFVDcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 23:32:17 -0400
Received: from mail.phunq.net ([184.71.0.62]:35710 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbaFVDcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 23:32:15 -0400
From: Daniel Phillips <daniel@phunq.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Sat, 21 Jun 2014 20:32:03 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
In-Reply-To: <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 21, 2014 12:29:01 PM PDT, James Bottomley wrote:
> On Thu, 2014-06-19 at 14:58 -0700, Daniel Phillips wrote:
>> We already removed 450 lines of core kernel workarounds from Tux3 with 
an 
>> approach that was literally cut and pasted from one of Dave's 
>> emails. Then 
>> Dave changed his mind. Now the Tux3 team has been assigned a research 
>> project to improve core kernel writeback instead of simply adapting the 
>> approach that is already proven to work well enough. That is a rather 
>> blatant example of "perfect is the enemy of good enough". Please read 
the 
>> thread.
>
> That's a bit disingenuous: the concern has always been how page forking
> interacted with writeback.  It's not new, it was one of the major things
> brought up at LSF 14 months ago, so you weren't just assigned this.

[citation needed]

Regards,

Daniel
