Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaLGQUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 11:20:08 -0500
Received: from blu004-omc1s29.hotmail.com ([65.55.116.40]:50583 "EHLO
	BLU004-OMC1S29.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaLGQUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 11:20:05 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2014 11:20:05 EST
X-TMN: [S8N7Lx827wETp6/Tx3y7rrM1oPq+U2Ws]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU436-SMTP2290D2D7C148D22663FD75E97670@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Chen Gang <gang.chen.5i5j@gmail.com>
In-Reply-To: <54832761.1050700@gmail.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value for all architectures
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox> <54822B19.2070804@gmail.com> <54832761.1050700@gmail.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 7 Dec 2014 11:14:42 -0500
CC: "jejb@parisc-linux.org" <jejb@parisc-linux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Joel Brobecker <brobecker@adacore.com>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 07 Dec 2014 16:14:59.0534 (UTC) FILETIME=[F2D63EE0:01D01238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6-Dec-14, at 10:57 AM, Chen Gang wrote:

> And I also want to consult about parisc assembly instructions, I can  
> not
> find the related reference documents, could you help to have a check  
> (or
> provide some related information for it)? related contents are below:

https://parisc.wiki.kernel.org/index.php/Technical_Documentation

Dave
--
John David Anglin	dave.anglin@bell.net



