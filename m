Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab3GSRUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:20:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34899 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3GSRUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:20:09 -0400
Message-ID: <51E97512.4040500@infradead.org>
Date: Fri, 19 Jul 2013 10:19:14 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for May 2 (platform/x86/samsung-laptop)
References: <20130502173537.c8aa671a1b22abe2ec341b87@canb.auug.org.au> <5182DA15.6030901@infradead.org>
In-Reply-To: <5182DA15.6030901@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 14:26, Randy Dunlap wrote:
> On 05/02/13 00:35, Stephen Rothwell wrote:
>> Hi all,
>>
>> Please do not add any v3.11 destined work to your linux-next included
>> branches until after v3.10-rc1 is released.
>>
>> Changes since 20130501:
>>
> 
> 
> when CONFIG_ACPI_VIDEO=m and CONFIG_SAMSUNG_LAPTOP=y:
> 
> drivers/built-in.o: In function `samsung_init':
> samsung-laptop.c:(.init.text+0x94ba): undefined reference to `acpi_video_unregister'
> 
> 
> 

This build error still happens in linux-next of 20130719...

-- 
~Randy
