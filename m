Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaAERx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:53:56 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55749 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAERxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:53:55 -0500
Message-ID: <52C99AE5.6040209@gmail.com>
Date: Sun, 05 Jan 2014 12:48:21 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Antti Heikkinen <antti.heikkinen.4@gmail.com>,
        linux-kernel@vger.kernel.org, advocacy@perl.org, beginners@perl.org
Subject: Re: Propose for LINUX kernel and PERL
References: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
In-Reply-To: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
X-Enigmail-Version: 1.6
OpenPGP: id=85D2EC0F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2014 12:46 AM, Antti Heikkinen wrote:
> To Dear Perl and LINUX kernel development community:
> 
> My propose to you at your list: is possible to write operate system
> in PERL? I am student in university, looked for interest project
> to conclude my study on LINUX kernel.
> 
> This semester, I take beginner PERL course and learn power of 
> procedural language. I automate many daily task with use of it.
> Very impressive ability to make many thing work, interpret or can
> compile also.
> 
> Also about LINUX, I talk to much fellow students and professors,
> and take a operate system course use FreeBSD and LINUX. FreeBSD
> okay, but they say LINUX kernel is too big and bloat, run poor with
> too many developer. And too much quick decision from leader with
> ego is too big and bloat too, kekeke.
> 
> LINUX kernel can perform more good if written in not C and C++ but 
> Perl? Just certain portion of LINUX kernel to rewrite? For
> instant, schedule or support of multithread? If so, should use
> Perl5 or Perl6, focus to x86 or x86-64? Can you want to join me
> this my project? But to hear your expertise.
No offense, but anyone who thinks that Perl (or any other interpreted
language except Lua) code will run faster than C is rather out of touch.
 C code doesn't have any of the translation overhead that interpreted
languages do. Perl is an extremely high level language, and thus suffers
from this even more (although it has been getting better about this in
recent years).  The only reason in fact that Lua manages to do almost as
well as native machine code compiled from C is that it uses a very
simple VM that is very similar in many respects to most modern processors.
> 
> Am excited to learn and begin study project. Can you want to join
> this my project? Please direct reply of email to myself.
> 
> Much thank to you, Antti Heikkinen
While I personally would never advocate a beginner trying to write an
entire OS because it is a HUGE undertaking (even more so in an
interpreted language like Perl), you might look into running Perl on
top of a micro-kernel like L4.  This would allow you to run Perl in
Ring 0/Kernel Mode.  If you wanted to use Lua instead (It's amazingly
easy to learn) then L4 would definitely be a good choice because the
init program for it already uses Lua.
