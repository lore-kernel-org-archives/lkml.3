Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3IFWIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:08:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37827 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3IFWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:08:07 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
Date: Fri, 6 Sep 2013 15:08:06 -0700
Message-ID: <CAOesGMgHwkU9Tih98ucDCqB815Abk=+e2TQNYkyMn-h0PY--pg@mail.gmail.com>
Subject: Re: [ 00/36] 3.10.11-stable review
From: Olof Johansson <olof@lixom.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 1:27 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.10.11 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
> and the diffstat can be found below.

FYI; I've started tracking the 3.10+ queues on my builder/booter for
arm-soc platforms.

I don't plan on posting the logs but will keep an eye on them and
report (new) failures that aren't seen on the baseline. I poll for new
patches a few times an hour.


-Olof
