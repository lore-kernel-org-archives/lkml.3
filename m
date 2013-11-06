Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3KFRRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:17:09 -0500
Received: from mail.candelatech.com ([208.74.158.172]:35326 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3KFRRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:17:07 -0500
Message-ID: <527A798F.7020809@candelatech.com>
Date: Wed, 06 Nov 2013 09:17:03 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is __ffs64 supposed to be zero based?
References: <5279ECA8.5080701@candelatech.com> <527A2D8B.6030901@ladisch.de>
In-Reply-To: <527A2D8B.6030901@ladisch.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 03:52 AM, Clemens Ladisch wrote:
> Ben Greear wrote:
>> Similarly named methods elsewhere seem to indicate it is supposed to be
>> ones-based counting (ie, bit (1<<0) would be considred 'bit 1'.
> 
> ffs() is defined to use one-based counting:
> <http://pubs.opengroup.org/onlinepubs/9699919799/functions/ffs.html>
> 
> __ffs() uses zero-based counting.  On gcc, it's likely to be implemented
> with__builtin_ctz*(), whose documentation says:
> | Returns the number of trailing 0-bits in x, starting at the least
> | significant bit position.

Thanks for the information!

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

