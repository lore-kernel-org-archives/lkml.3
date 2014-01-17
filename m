Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaAQKGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:06:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaAQKGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:06:41 -0500
Message-ID: <52D900A4.9020509@redhat.com>
Date: Fri, 17 Jan 2014 11:06:28 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: "'Hannes Frederic Sowa'" <hannes@stressinduktion.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: add trim helper and convert users
References: <1389918519-23779-1-git-send-email-hannes@stressinduktion.org> <1389918519-23779-3-git-send-email-hannes@stressinduktion.org> <063D6719AE5E284EB5DD2968C1650D6D45EAC0@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45EAC0@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 10:52 AM, David Laight wrote:
> From: Hannes Frederic Sowa
> ...
>> +/**
>> + * trim - perform a reciprocal multiplication in order to "clamp" a
>> + *        value into range [0, ep_ro), where the upper interval
>> + *        endpoint is right-open. This is useful, e.g. for accessing
>> + *        a index of an array containing ep_ro elements, for example.
>> + *        Think of it as sort of modulus, only that the result isn't
>> + *        that of modulo. ;)
>> + *        More: http://homepage.cs.uiowa.edu/~jones/bcd/divide.html
>
> It isn't appropriate to put urls into code comments (or commit messages).
> They are very likely to get out of date.

Then please grep the git log for some references/urls, you'll find plenty.
This link is just a pointer for people interested to read some more
background; there's no need to overly elaborate in the kernel doc right
here.

Thanks !

> 	David
>
>
>
