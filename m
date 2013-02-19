Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3BSQxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:53:47 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63526 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab3BSQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:53:45 -0500
Message-ID: <5123AE15.1010204@suse.cz>
Date: Tue, 19 Feb 2013 17:53:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: =?UTF-8?B?RGlldGVyIE7DvHR6ZWw=?= <dieter@nuetzel-hh.de>
CC: =?UTF-8?B?QW5qYSBOw7x0emVs?= <Anja@nuetzel-hh.de>,
        Alan Stern <stern@rowland.harvard.edu>, Jeff Mahoney <jeffm@suse.com>,
        mmarek@suse.cz, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] openSUSE 12.2 stable kernel 3.7.8-1 big USB 2.0
 slowdown
References: <Pine.LNX.4.44L0.1302182155510.12532-100000@netrider.rowland.org> <512342F8.5060200@suse.cz> <c4dc6832f4c82adb3a87a3a42c5e67d6@mail.ud03.udmedia.de>
In-Reply-To: <c4dc6832f4c82adb3a87a3a42c5e67d6@mail.ud03.udmedia.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 05:44 PM, Dieter Nützel wrote:
> Am 2013-02-19 10:16, schrieb Jiri Slaby:
>> On 02/19/2013 03:56 AM, Alan Stern wrote:
>>> A lot of people have reported problems caused by the last one
>>> (269ef9f).  I haven't had time to investigate yet (just got back from
>>> vacation).
>>
>> I reverted that one in:
>> http://labs.suse.cz/jslaby/bug-804367/
>>
>> Anja, could you test that kernel?
> 
> "Anja's" kernel (your kernel-desktop-3.7.9-0.i686.rpm) works OK!
> 
> openSUSE stable (kernel-desktop-3.7.9-1.1) of course NOT.

I've just pushed the revert:
   e224175..ba0ac30  openSUSE-12.3 -> openSUSE-12.3
   f3ee42f..83cb8d1  master -> master
   ae1c506..e56d580  stable -> stable
-- 
js
suse labs
