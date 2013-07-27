Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3G0LWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 07:22:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57541 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3G0LWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 07:22:32 -0400
Message-ID: <20130727062230.5580181gtrfxe83k@67.228.131.205>
Date: Sat, 27 Jul 2013 06:22:30 -0500
From: linux@roeck-us.net
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/45] 3.0.88-stable review
References: <20130726205654.896050165@linuxfoundation.org>
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg Kroah-Hartman <gregkh@linuxfoundation.org>:

> This is the start of the stable review cycle for the 3.0.88 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 28 20:54:53 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.88-rc1.gz
> and the diffstat can be found below.
>
We have additional build failures.

Total builds: 54 Total build errors: 20

Link:  
http://desktop.roeck-us.net/buildlogs/v3.0.87-45-g367423c.2013-07-27.03:09:16

Previously:
Total builds: 54 Total build errors: 17

Additional failures are i386/allmodconfig, i386/allyesconfig and mips/malta.

I don't have time to track down the culprit tonight (I am still in  
Down Under ;). I hope I can do it tomorrow.

Guenter

