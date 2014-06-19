Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbaFSWOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:14:19 -0400
Received: from mail.phunq.net ([184.71.0.62]:33672 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaFSWOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:14:18 -0400
From: Daniel Phillips <daniel@phunq.net>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <tux3@tux3.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Thu, 19 Jun 2014 15:14:14 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <d148ea1a-ad67-481f-843e-54466f9d495d@phunq.net>
In-Reply-To: <53A30EAA.1010504@fb.com>
References: <5376B273.7000800@partner.samsung.com> <53A30EAA.1010504@fb.com>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 19, 2014 9:24:10 AM PDT, Josef Bacik wrote:
>
> On 05/16/2014 05:50 PM, Daniel Phillips wrote:
>> We would like to offer Tux3 for review for mainline merge. We 
>> have prepared a new repository suitable for pulling:
>> 
>> 
https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HU1zkg6rNOpSE0e5%2FKr7FH%2B2v8AbariYTtSijfNFsCY%3D%0A&s=941c4856b064898f9f05c0337b06db718dab951d8e65fccffaced7bd1d5e91a2
>> 
>> Tux3 kernel module files are here:
>> 
>> 
https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HU1zkg6rNOpSE0e5%2FKr7FH%2B2v8AbariYTtSijfNFsCY%3D%0A&s=2471ce8b7706ede604604a5be7130daeb9424b7197122a66491c365525fbabe1
>> 
>> Tux3 userspace tools and test ...
>
> So I'd really like to see the page fork stuff broken out in their own 
core
> change.  I want to do something like this to get around the stable pages
> pain but haven't had the time to look at it, so if we can hammer out what
> you guys did into something workable and generic that would be great.

Hirofumi has been working on just that for the last couple of weeks (his
usual attention to detail) and there are still a few days to go on it. We
would appreciate it if somebody else does the hammering for a generic
version, so we can continue to concentrate on getting the core hooks
righ, proving out the corner cases, and proving the benefit through
benchmarks :)

The next round of Tux3 review patches will be two separate patch series,
one for writeback core hooks, and one for page forking core hooks. These
will be against Hirofumi's mirror at Github, to keep the kernel.org git
tree history clean and unrebased.

Regards,

Daniel

