Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337Ab3HIDmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:42:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53917 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967443Ab3HIDmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:42:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52046514.3000804@roeck-us.net>
Date: Thu, 08 Aug 2013 20:42:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/22] 3.0.90-stable review
References: <20130809013949.226228694@linuxfoundation.org>
In-Reply-To: <20130809013949.226228694@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 06:41 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.90 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 11 01:37:07 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.90-rc1.gz
> and the diffstat can be found below.
>

Cross build results:
	Total builds: 58 Total build errors: 14

Same result as with previous release, except I got the m68k builds to work on 3.0,
added some new builds, and removed others which were failing on all branches.

Details:
	http://server.roeck-us.net:8010/builders/stable-queue-3.0/builds/29/steps/shell/logs/stdio/text

If anyone is interested in detailed per-build logs, please let me know.

Guenter

