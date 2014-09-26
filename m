Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaIZRC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:02:57 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:53252 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaIZRCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:02:55 -0400
Message-ID: <54259C3D.4040207@gmail.com>
Date: Fri, 26 Sep 2014 13:02:53 -0400
From: nick <yocto6@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Ivo Van Doorn <IvDoorn@gmail.com>, helmut.schaa@googlemail.com,
        John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
        "julia.lawall@lip6.fr oneukum@suse.de" <linux-kernel@vger.kernel.org>
Subject: Re: FIXMEs in rt2800lib.c
References: <5424566B.6000206@gmail.com>	<20140926122207.GA27809@redhat.com> <CAAxn8J=gKVdNt3+Ayx-XdEki7V8sg-M7C=kK7sGADBO3L-PTQw@mail.gmail.com>
In-Reply-To: <CAAxn8J=gKVdNt3+Ayx-XdEki7V8sg-M7C=kK7sGADBO3L-PTQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14-09-26 09:32 AM, Nicholas Krause wrote:
> On Fri, Sep 26, 2014 at 8:22 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Thu, Sep 25, 2014 at 01:52:43PM -0400, nick wrote:
>>> I seem to be hitting to fix mes in the file I listed in the subject. Would someone tell me if it's Ok to remove
>>> the lines that over write certain registers.
>>
>> No, as long you prove that they are not needed.
>>
>> Stanislaw
> Sure Stanislw,
> I will remove the lines as needed and send it a patch.
> Nick
> 
Is that a typo and a yes or not?
Nick 
