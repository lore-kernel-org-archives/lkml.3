Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBKSOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:14:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48154 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaBKSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:14:29 -0500
Message-ID: <52FA6881.4030602@gmail.com>
Date: Tue, 11 Feb 2014 19:14:25 +0100
From: Bastien Traverse <bastien.traverse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Wu <lekensteyn@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        francis.moro@gmail.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <2087423.Qy7HQIx1X6@vostro.rjw.lan> <52F7CC8B.1020209@gmail.com> <2182978.C0zdYi5cqX@al>
In-Reply-To: <2182978.C0zdYi5cqX@al>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/02/2014 23:07, Peter Wu a écrit :
> I think this is relevant. See also my test with 3.13.2 and different
> kernel configs[1]. A workaround that triggers a scan was also posted[2].
> 
> Peter
> 
>  [1]: http://lkml.org/lkml/2014/2/8/264
>  [2]: http://lkml.org/lkml/2014/2/7/809

Thanks, I can confirm that triggering a rescan by issuing

  sudo tee /sys/devices/pci0000:00/0000:00:1c.1/rescan <<<1

made the device reappear on my system (of course I had to adapt the
command to match PCI Bridge number). That's a handy workaround, it
avoids restarting each time.

As I've never compiled a kernel so far I think I'll leave the
configuration tweaks for another time :)

Cheers
