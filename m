Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaA3NnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:43:03 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:60888 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaA3NnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:43:00 -0500
Message-ID: <52EA56E1.40507@6wind.com>
Date: Thu, 30 Jan 2014 14:42:57 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH 0/2] [BUG FIXES - 3.10.27] sit: More backports
References: <20140128205756.074448668@goodmis.org>	<52E8E025.2060803@6wind.com>	<20140129075745.4227a2ed@gandalf.local.home>	<52E9267C.90403@6wind.com>	<20140129154811.27fbaf13@gandalf.local.home>	<52EA1B4B.5080403@6wind.com> <20140130083103.2bc68bad@gandalf.local.home>
In-Reply-To: <20140130083103.2bc68bad@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/01/2014 14:31, Steven Rostedt a écrit :
> On Thu, 30 Jan 2014 10:28:43 +0100
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>
>
>> Steve, I think the patch I sent yesterday is the good fix. At the end, it's
>> a backport of Willem's patch. Note that he also ack that patch.
>> The first version you sent (which removes
>> unregister_netdevice_queue(sitn->fb_tunnel_dev, &list)) will introduce a
>> memory leak when the user destroy a netns.
>
> Hi Nicolas,
>
> I reverted my patches and applied and tested your patches locally and
> they passed my first line testing. I'm going to have them entered into
> our test suite, after removing our other patches, and see if they solve
> all the bugs that we were tripping over.
>
> I'll let you know when these are finished.
Thank you for testing.


Regards,
Nicolas
