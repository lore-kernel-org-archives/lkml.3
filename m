Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734AbaH1KvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:51:13 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:38090 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503AbaH1KvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <53FF0765.3050509@intel.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
 <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
 <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
 <53FF0765.3050509@intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 28 Aug 2014 12:50:47 +0200
Message-ID: <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Thu, Aug 28, 2014 at 12:41 PM, Mathias Nyman <mathias.nyman@intel.com> wrote:
> On 08/27/2014 07:10 PM, Ricardo Ribalda Delgado wrote:
>> Perhaps we could apply both patches to current tree and backport mine
>> to older kernels?
>>
>
> The already applied patch fixes many other issues than just this one.
> backporting it to stable < 3.13 turned out to not be that difficult, stable maintainers
> said they can do it themselves.

then I agree, there is absolutely no need for my patch :).

I have a broken gadget driver that was very good at triggering the
bug, I will try it out with your patch.


Thanks!

>
> Stable kernels prefer patches that are already upstream, as Documentation/stable_kernel_rules.txt states:
> "- It or an equivalent fix must already exist in Linus' tree (upstream)."
>
> There is no need for the other patch anymore, not upstream nor to stable
>
> -Mathias
>



-- 
Ricardo Ribalda
