Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3EUTbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:31:47 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:53082 "EHLO Ishtar.hs"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076Ab3EUTbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:31:46 -0400
Message-ID: <519BCB96.6050908@tlinx.org>
Date: Tue, 21 May 2013 12:31:34 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: util-linux@vger.kernel.org, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mount --no-canonical seems broken.
References: <5175BA15.9060803@tlinx.org> <20130423123648.GB24501@x2.net.home> <517729C7.2030806@tlinx.org> <20130520074001.GE16493@x2.net.home> <519AB20D.7030503@tlinx.org> <20130521094711.GD11688@x2.net.home>
In-Reply-To: <20130521094711.GD11688@x2.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





Karel Zak wrote:
> On Mon, May 20, 2013 at 04:30:21PM -0700, Linda Walsh wrote:
>   
>>  widely known as "df" or "mount".
>>
>> I might point out that by default,
>>     
>>> findmnt /
>>>       
>> TARGET SOURCE    FSTYPE OPTIONS
>> /      /dev/root xfs    rw,nodiratime,relatime,attr2,inode64,noquota
>>     
>>>> l /dev/root
>>>>         
>> ls: cannot access /dev/root: No such file or directory
>>     
>
>  util-linux 2.23 ? 
>  
>  libmount since this version is able to use the root= kernel command
>  line option to convert /dev/root from the /proc/self/mountinfo file
>  to a real device name.
>   
----
    I'm only at 2.19, will get & try newer version.  Thanks!


