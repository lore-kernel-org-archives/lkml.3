Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3DOODw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:03:52 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56594 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3DOODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130415020614.067692418@linuxfoundation.org>
References: <20130415020614.067692418@linuxfoundation.org>
Date: Mon, 15 Apr 2013 08:03:49 -0600
Message-ID: <CAKocOONkHStiUyfthfV5v0gK3O_P6a1fwVOKcomrsgUyqSbhtg@mail.gmail.com>
Subject: Re: [ 00/11] 3.0.74-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 8:17 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.74 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Apr 17 02:05:34 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.74-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches applied cleanly to 3.0.73, 3.4.40, and 3.8.7

Compiled and booted on the following systems:

HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
(on the road, only one system and no cross compile tests this time)

dmesgs for all releases look good. No regressions compared to the previous
dmesgs for each of these releases.

cross compile tests - skipped

-- Shuah
