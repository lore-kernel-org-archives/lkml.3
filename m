Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaCMSBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:01:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60621 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaCMSBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:01:34 -0400
MIME-Version: 1.0
In-Reply-To: <1394733526.32465.250.camel@willson.li.ssimo.org>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
 <1394657163-7472-3-git-send-email-vgoyal@redhat.com> <5320CAEC.6030008@amacapital.net>
 <CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
 <1394658983.32465.203.camel@willson.li.ssimo.org> <CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
 <1394673476.32465.215.camel@willson.li.ssimo.org> <CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
 <1394675038.32465.223.camel@willson.li.ssimo.org> <CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
 <1394733077.32465.243.camel@willson.li.ssimo.org> <CALCETrXWzja6W6y=p9MrtynGZMsrD5KQu0KBK6Bs1dQxnesv2A@mail.gmail.com>
 <1394733526.32465.250.camel@willson.li.ssimo.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Mar 2014 11:01:14 -0700
Message-ID: <CALCETrWtVEjPGoJLe0CDuNW2cpSmh+ZvHOXJ_pLeZ=x+UUcShQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
To: Simo Sorce <ssorce@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:58 AM, Simo Sorce <ssorce@redhat.com> wrote:
> On Thu, 2014-03-13 at 10:55 -0700, Andy Lutomirski wrote:
>>
>> So give each container its own unix socket.  Problem solved, no?
>
> Not really practical if you have hundreds of containers.

I don't see the problem.  Sockets are cheap.

>
> Simo.
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
