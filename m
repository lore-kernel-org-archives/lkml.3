Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaLDRrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:47:46 -0500
Received: from mx2.compro.net ([12.186.155.30]:59818 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932343AbaLDRro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:47:44 -0500
X-BYPSHEADER: 2124884
X-SMScore: -200
Message-ID: <54809E3F.7050605@compro.net>
Date: Thu, 04 Dec 2014 12:47:43 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Sean Cleator <seancleator@hotmail.co.uk>
CC: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: dgnc: Fix long line coding style issues in
 dgnc_cls.h
References: <BLU437-SMTP3735424C7098C20996EFF8E97B0@phx.gbl> <1723574984.368832.1417649865878.JavaMail.root@mx2.compro.net>
In-Reply-To: <1723574984.368832.1417649865878.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 06:37 PM, Joe Perches wrote:
> On Wed, 2014-12-03 at 21:30 +0000, Sean Cleator wrote:
>> A patch to fix the rest of the long line warnings in the dgnc_cls.h file
>> found by the checkpatch.pl tool
>
> checkpatch is a brainless little tool.
>
> You should prefer to develop a readable style rather than
> pay too close attention to precisely what checkpatch says.
>
> fyi: There is this warning in the file:
>
>   *	NOTE: THIS IS A SHARED HEADER. DO NOT CHANGE CODING STYLE!!!
>

That comment should be removed. It was put there when this driver was 
under Digi's CVS control. Some of their user land apps, delivered with 
the driver package, also used it. They probably had different people 
working on the kernel and user land side.

Mark
