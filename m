Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3L2UZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 15:25:55 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45227 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3L2UZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 15:25:54 -0500
Message-ID: <52C0854D.2090802@googlemail.com>
Date: Sun, 29 Dec 2013 21:25:49 +0100
From: Stefan Beller <stefanbeller@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: PINTU KUMAR <pintu_agarwal@yahoo.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: Help about calculating total memory consumption during booting
References: <1388341026.52582.YahooMailNeo@web160105.mail.bf1.yahoo.com>
In-Reply-To: <1388341026.52582.YahooMailNeo@web160105.mail.bf1.yahoo.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.12.2013 19:17, PINTU KUMAR wrote:
> Hi,
> 
> I need help in roughly calculating the total memory consumption in an embedded Linux system just after booting is finished.
> I know, I can see the memory stats using "free" and "/proc/meminfo"
> 
> But, I need the breakup of "Used" memory during bootup, for both kernel space and user application.
> 
> Example, on my ARM machine with 128MB RAM, the free memory reported is roughly:
> Total: 90MB
> Used: 88MB
> Free: 2MB
> Buffer+Cached: (5+19)MB
> 
> Now, my question is, how to find the breakup of this "Used" memory of "88MB".
> This should include both kernel space allocation and user application allocation(including daemons).
> 

http://www.linuxatemyram.com/ dont panic ;)

How about htop, top or
"valgrind --tool massif"




