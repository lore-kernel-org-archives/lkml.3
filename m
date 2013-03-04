Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3CDDPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:15:06 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41860 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3CDDPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:15:04 -0500
Message-ID: <513411AD.5010408@linux.vnet.ibm.com>
Date: Mon, 04 Mar 2013 11:14:53 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com> <1362107325.2712.2.camel@localhost> <20130301035417.GA17236@concordia>
In-Reply-To: <20130301035417.GA17236@concordia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030403-6102-0000-0000-000003173E46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/3/1 11:54, Michael Ellerman 写道:
> On Fri, Mar 01, 2013 at 11:08:45AM +0800, Mike wrote:
>> Hi all
>>
>> Any comments? or any questions about my patchset?
> You were going to get some performance numbers that show a definite
> benefit for using more than one MSI.
Yes, but my patch just enable the kernel to support this feature, whether
to use it depens on the device driver.

And this feature has been merged to the kernel for X86 for a long time.
See commit: 5ca72c4f7c412c2002363218901eba5516c476b1
51906e779f2b13b38f8153774c4c7163d412ffd9

Actually, I'm trying to do the test. but it is difficult to do that test,
because it mostly depends on how the device driver to use this feature,
while the ipr driver patch was wrote by another person. also no any reply
from her.


> cheers
>

