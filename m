Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3DWWxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:53:05 -0400
Received: from mail.afriserver.de ([5.9.107.143]:47184 "EHLO
	mail.afriserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3DWWxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:53:03 -0400
Message-ID: <517710CD.3020205@felixbecker.name>
Date: Wed, 24 Apr 2013 00:53:01 +0200
From: Felix Becker <mail@felixbecker.name>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Eric Wong <normalperson@yhbt.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: socket file descriptor a/m/c-timestamps broken in <= 3.8.8?
References: <5175CA2F.2030206@felixbecker.name>  <20130423003015.GA26858@dcvr.yhbt.net> <1366677456.16391.101.camel@edumazet-glaptop>
In-Reply-To: <1366677456.16391.101.camel@edumazet-glaptop>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thank you for that info. Can you tell which mailing list the right one
for this issue is?

Felix

On 04/23/2013 02:37 AM, Eric Dumazet wrote:
> On Tue, 2013-04-23 at 00:30 +0000, Eric Wong wrote:
>> Cc:-ing netdev (no comments of my own)
>> 
>> Felix Becker <mail@felixbecker.name> wrote:
>>> Hi,
>>> 
>>> I tried to figure out how old my TCP connections are and took
>>> a look at /proc/<pid>/fd/<socketfdnum> using 'ls -la' /
>>> 'stat'.
>>> 
> 
> Thanks, but its not a network issue, /proc/pid/fd are part of 
> another subsystem.
> 
> In particular, a/m/c timestamps are volatile (not meaningfull), as 
> you can make them disappear by "echo 3 >/proc/sys/vm/drop_caches"
> 
> Next time you use "ls /proc/pid/fd/..." timestamps are created.
> 
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
> 

