Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaAFBpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:45:43 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:51904 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaAFBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:45:42 -0500
MIME-Version: 1.0
In-Reply-To: <52C99AE5.6040209@gmail.com>
References: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
	<52C99AE5.6040209@gmail.com>
Date: Mon, 6 Jan 2014 09:45:41 +0800
Message-ID: <CAGdX0WE2H54j7e6ksGT8yccpcvfNQjVYhWqE0uBe8oBA4Qc-FA@mail.gmail.com>
Subject: Re: Propose for LINUX kernel and PERL
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Antti Heikkinen <antti.heikkinen.4@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, advocacy@perl.org,
        beginners@perl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 1:48 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 01/05/2014 12:46 AM, Antti Heikkinen wrote:
>> To Dear Perl and LINUX kernel development community:
>>
>> My propose to you at your list: is possible to write operate system
>> in PERL? I am student in university, looked for interest project
>> to conclude my study on LINUX kernel.
>>
>> This semester, I take beginner PERL course and learn power of
>> procedural language. I automate many daily task with use of it.
>> Very impressive ability to make many thing work, interpret or can
>> compile also.
>>
>> Also about LINUX, I talk to much fellow students and professors,
>> and take a operate system course use FreeBSD and LINUX. FreeBSD
>> okay, but they say LINUX kernel is too big and bloat, run poor with
>> too many developer. And too much quick decision from leader with
>> ego is too big and bloat too, kekeke.
>>
>> LINUX kernel can perform more good if written in not C and C++ but
>> Perl? Just certain portion of LINUX kernel to rewrite? For
>> instant, schedule or support of multithread? If so, should use
>> Perl5 or Perl6, focus to x86 or x86-64? Can you want to join me
>> this my project? But to hear your expertise.
> No offense, but anyone who thinks that Perl (or any other interpreted
> language except Lua) code will run faster than C is rather out of touch.
>  C code doesn't have any of the translation overhead that interpreted
> languages do. Perl is an extremely high level language, and thus suffers
> from this even more (although it has been getting better about this in
> recent years).  The only reason in fact that Lua manages to do almost as
> well as native machine code compiled from C is that it uses a very
> simple VM that is very similar in many respects to most modern processors.
>>
Just FYI, ktap is for "lua in Linux kernel". :)
The lua VM is pretty simple and the instruction could translate to machine
code easily, the cool thing is luajit project already proved this.

Thanks,

Jovi
