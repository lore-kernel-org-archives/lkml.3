Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3GBGFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:05:21 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:40031 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab3GBGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:05:18 -0400
Message-ID: <51D26D9B.10301@free.fr>
Date: Tue, 02 Jul 2013 08:05:15 +0200
From: Eric Valette <eric.valette@free.fr>
Reply-To: eric.valette@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: eric.valette@free.fr
Subject: Re: memmap exclude boot command: how to check if it was indeed applied
References: <51D1CD3B.80804@free.fr>
In-Reply-To: <51D1CD3B.80804@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 20:40, Eric Valette wrote:
> Hi,
>
> After  hunting an unreproducible bug, I decided to run memtest86+ and
> found that only 8 byte of memory refuse to write the last two digit on
> the last 4GB memory stick.
>
> Memory is at 0x31db357558
>
> So I decided to add a memmap=4K@0x000000031db35000 boot options in
> GRUB_CMDLINE_LINUX. But checking dmesg, I see no mention of this page
> being reserved.
>
> PS: CC me I'm not subscribed.

Analysing /sys/firmware/memmap files, I see no trace of buggy address 
exclusion. Any help?



--eric

