Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3CDPVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:21:37 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61226 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3CDPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:21:36 -0500
Message-ID: <5134BBFC.2050907@suse.cz>
Date: Mon, 04 Mar 2013 16:21:32 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
        linux-kernel@vger.kernel.org
CC: e1000-devel@lists.sourceforge.net
Subject: Re: e1000e: nic does not work properly after cold power on
References: <20130304124631.2ac730f3@mdontu-l.dsd.ro>
In-Reply-To: <20130304124631.2ac730f3@mdontu-l.dsd.ro>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 11:46 AM, Mihai Donțu wrote:
> Hi,
> 
> I apologize in advance for posting on two lists at once and for not
> even being subscribed to e1000-devel.
> 
> Ever since upgrading to 3.8.x, I'm unable to use my wired connection
> (e1000e - Intel Corporation 82579LM Gigabit) immediately after power
> on. I have to boot into an older kernel (3.2.0 I happen to have around)
> and _then_ boot into 3.8.1. There are no errors in dmesg that I can
> see. The only one behaving strangely is NetworkManager who simply says
> the device is managed and skips it. Also, there's no 'link becomes
> ready' in dmesg either (and I swear the cable is plugged in).
> 
> Has anyone else encountered this?

Hi, I think so:
http://lists.opensuse.org/opensuse-factory/2013-03/msg00099.html

(I have no idea what the issue is, just adding another report.)

-- 
js
suse labs
