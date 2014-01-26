Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaAZQ3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 11:29:04 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37401 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaAZQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 11:29:03 -0500
Message-ID: <52E537CB.40607@gmail.com>
Date: Sun, 26 Jan 2014 16:28:59 +0000
From: Aaron Jones <aaronmdjones@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: File capabilities are not 'working' and I have no idea why
References: <52DE7557.3000500@gmail.com> <20140126162228.GA6946@mail.hallyn.com>
In-Reply-To: <20140126162228.GA6946@mail.hallyn.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/14 16:22, Serge E. Hallyn wrote:
> Hm, I'm running Ubuntu 3.13.0-5-generic and I do get
>
> serge@tp:~/test$ ./caps
> Effective capabilities:
> net_bind_service
> Permitted capabilities:
> net_bind_service
>
> Any chance (grasping for straws here) that the hardening patches
> are interfering?  Can you try hand-building an upstream kernel to
> test with?

I downloaded a vanilla 3.12.8 tree directly from kernel.org
for the purposes of my previous post. I was running that kernel
then... I also have the same problem with the hardened kernel now.

I'm at a loss as to why it doesn't work on 3.12.8, but it does on
3.10.7, hardening patches or not.


