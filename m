Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab3GVUBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:01:51 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64984 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab3GVUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:01:50 -0400
MIME-Version: 1.0
In-Reply-To: <51ED882F.9080801@nod.at>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <20130722124047.GL4165@ZenIV.linux.org.uk> <CALkWK0=bAwDxbLEtHOThjY58BmWCrFYgZm9GaLfEnF5vpu1VJw@mail.gmail.com>
 <51ED31AF.8000309@nod.at> <CALkWK0ki0JN_uB3VNr=j0hAcEhiT_Xr+xd911-AGy5sjd95GFg@mail.gmail.com>
 <51ED3CF5.7000609@nod.at> <CALkWK0kwBaNHfH6fjtnCTxseWcXfEvNFgFovZVkz5E0_fxiHWA@mail.gmail.com>
 <51ED882F.9080801@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 23 Jul 2013 01:31:09 +0530
Message-ID: <CALkWK0mVX21Y7xH+uPjKVBGmHqo4HW1uFRGvpKxWHTQdhV8Ehw@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> No, but we won't break existing applications, period.

We're on the same page: I'm absolutely against breaking existing users too.

> If you offer me a solution that does not break any existing applications
> and solves your systemd issue we can talk. :-)

I think a hv console driver for um Linux will solve the problem, but I
can't be sure.  I'm trying to write one, and I'll hopefully have
something to show in a few more caffeinated hours.

Let me know if you have any thoughts/ pointers.
