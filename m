Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbaIEOuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:50:13 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55634 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaIEOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:50:10 -0400
Message-ID: <5409CE2C.8000609@gmail.com>
Date: Fri, 05 Sep 2014 16:52:28 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-pm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.10.y+] PM / sleep: Use valid_state() for platform-dependent
 sleep states only
References: <1849024.CHOUso6H2K@vostro.rjw.lan> <1409865665-5375-1-git-send-email-computersforpeace@gmail.com> <54095835.7000207@gmail.com> <20140905074512.GA12218@brian-ubuntu>
In-Reply-To: <20140905074512.GA12218@brian-ubuntu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 09:45 AM, Brian Norris wrote:
> On Fri, Sep 05, 2014 at 08:29:09AM +0200, Francis Moreau wrote:
>> On 09/04/2014 11:21 PM, Brian Norris wrote:
> [...]
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> Cc: <stable@vger.kernel.org> # 3.10+: 27ddcc6596e5: PM / sleep: Add state field to pm_states[] entries
>>> Cc: <stable@vger.kernel.org> # 3.10+
>>> ---
>>> This is a backport request for these two commits upstream:
>>>
>>>     27ddcc6596e5 PM / sleep: Add state field to pm_states[] entries
>>>     43e8317b0bba PM / sleep: Use valid_state() for platform-dependent sleep states only
>>>
>>
>> Wouldn't it be cleaner to have 2 separate backports then ?
> 
> The first is purely a dependency for the second. It has no value on its
> own. So I thought the above form made sense and followed the process
> mentioned in Documentation/stable_kernel_rules.txt.
> 
> Admittedly, it's a little asymmetric. But I really don't know what the
> "best" option is, since I'd prefer not having to send around any patch
> text at all, unless the backport is not trivial (these apply cleanly).

I don't know, I just find cleaner to cherry-pick upstream commits when
possible so I can retrieve them easily later when inspecting a stable
kernel.

My 2 cents.
