Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaLGW2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:28:47 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56587 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaLGW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:28:46 -0500
Message-ID: <5484D631.4010606@gmail.com>
Date: Mon, 08 Dec 2014 06:35:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John David Anglin <dave.anglin@bell.net>
CC: "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Joel Brobecker <brobecker@adacore.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox> <54822B19.2070804@gmail.com> <54832761.1050700@gmail.com> <BLU436-SMTP2290D2D7C148D22663FD75E97670@phx.gbl>
In-Reply-To: <BLU436-SMTP2290D2D7C148D22663FD75E97670@phx.gbl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/8/14 00:14, John David Anglin wrote:
> On 6-Dec-14, at 10:57 AM, Chen Gang wrote:
> 
>> And I also want to consult about parisc assembly instructions, I can not
>> find the related reference documents, could you help to have a check (or
>> provide some related information for it)? related contents are below:
> 
> https://parisc.wiki.kernel.org/index.php/Technical_Documentation

OK, thank you very much!!

For me, these information is enough, I checked the related sub link, it
has a full description for all related instruction (stb/h, stw, std).

  https://parisc.wiki.kernel.org/images-parisc/7/73/Parisc2.0.pdf

For me, my original comments need be improved: need mention about STH,
and maybe also need consider about additional related instructions of
parisc 2.0 (STDA, STWA, STBY, STDBY).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
