Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbaAEITL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 03:19:11 -0500
Received: from blu0-omc1-s16.blu0.hotmail.com ([65.55.116.27]:40094 "EHLO
	blu0-omc1-s16.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbaAEITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 03:19:09 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2014 03:19:09 EST
X-TMN: [dL2jNyiW7VHF5/r1XR1Ug4/KPdluLrT3]
X-Originating-Email: [bulk88@hotmail.com]
Message-ID: <BLU0-SMTP270AA353C093297F94C7B85DFB40@phx.gbl>
Date: Sun, 5 Jan 2014 03:12:17 -0500
From: bulk88 <bulk88@hotmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.24) Gecko/20100228 SeaMonkey/1.1.19
MIME-Version: 1.0
To: Antti Heikkinen <antti.heikkinen.4@gmail.com>
CC: linux-kernel@vger.kernel.org, advocacy@perl.org, beginners@perl.org
Subject: Re: Propose for LINUX kernel and PERL
References: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
In-Reply-To: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2014 08:13:58.0343 (UTC) FILETIME=[156DFD70:01CF09EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Antti Heikkinen wrote:
> To Dear Perl and LINUX kernel development community:
> 
> My propose to you at your list: is possible to write operate system in
> PERL? I am student in university, looked for interest project to
> conclude my study on LINUX kernel.
> 
> This semester, I take beginner PERL course and learn power of
> procedural language. I automate many daily task with use of it. Very
> impressive ability to make many thing work, interpret or can compile
> also.
> 
> Also about LINUX, I talk to much fellow students and professors, and
> take a operate system course use FreeBSD and LINUX. FreeBSD okay, but
> they say LINUX kernel is too big and bloat, run poor with too many
> developer. And too much quick decision from leader with ego is too big
> and bloat too, kekeke.
> 

I agree, Linux kernel is hacks on hacks with no top to bottom 
architecture. Linux had the BKL longer than its competitors. Linux was 
never whiteboarded before the project began. FreeBSD is more organized 
and uniform. There is also NT Kernel whose API was speced out before the 
kernel was written.

> LINUX kernel can perform more good if written in not C and C++ but
> Perl? Just certain portion of LINUX kernel to rewrite? For instant,
> schedule or support of multithread? If so, should use Perl5 or Perl6,
> focus to x86 or x86-64? Can you want to join me this my project? But
> to hear your expertise.

Since Perl is Turing complete you can run the Linux kernel inside Perl. 
Although Perl doesn't run in kernel mode ATM, I don't see why I can't be 
ported to be a LKM, maybe with RPC to glibc. You could also have Perl 
running as user mode driver or some kind daemon with calls from a kernel 
driver to the user space daemon Perl. You can use Perl version 5 or 6.
