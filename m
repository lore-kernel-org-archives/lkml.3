Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935384AbaH0QLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:11:03 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59710 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935137AbaH0QLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:11:00 -0400
MIME-Version: 1.0
In-Reply-To: <53FDF8D9.60103@intel.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
 <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
 <53FDF8D9.60103@intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 27 Aug 2014 18:10:40 +0200
Message-ID: <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps we could apply both patches to current tree and backport mine
to older kernels?

On Wed, Aug 27, 2014 at 5:27 PM, Mathias Nyman <mathias.nyman@intel.com> wrote:
> On 08/27/2014 05:14 PM, Ricardo Ribalda Delgado wrote:
>> At least I have seen the issue on Debian 3.14 and 3.16. Is your patch
>> going to be backported to linux-stable? The computer crashes very very
>> badly
>>
>
> Yes, it is, but it might need some additional work as it won't apply cleanly on older versions
>
> http://marc.info/?l=linux-usb&m=140913688327011&w=2
>
> -Mathias



-- 
Ricardo Ribalda
