Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaIAMOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:14:49 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34670 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIAMOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <540465D0.6000003@linux.intel.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
 <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
 <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
 <53FF0765.3050509@intel.com> <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com>
 <CAPybu_1UytoxXk-t7u_3vQ6KL-5DmVUz1u5PiDLysBCvgit--A@mail.gmail.com>
 <53FF48B1.5090901@intel.com> <CAPybu_2rgn-DEUKfdmGsaAsFSQJ_zz6fsdnD0dHmyCPW4B-+WA@mail.gmail.com>
 <54009A50.9010707@intel.com> <CAPybu_2ZQ9iPA_FfYn2Mqg5vXn40HuFCcVv1Zg900YavKCDxUQ@mail.gmail.com>
 <CAPybu_3qmtob-uJhcUwEETcM7cXPxOm3-zOjNFLub31mQDdABQ@mail.gmail.com>
 <54044C5C.9010305@intel.com> <CAPybu_3jtJDXw1rJOQVoc2G9UmDXqeaLW-aNvfO=y306XQoXjQ@mail.gmail.com>
 <54045485.4080700@intel.com> <CAPybu_009Z7Ehak_CGMAfO80hWKC=w2LoUQjg0B-aQwqd58H6w@mail.gmail.com>
 <540465D0.6000003@linux.intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 1 Sep 2014 14:14:26 +0200
Message-ID: <CAPybu_1Jvn2vMjcY863JCz08SZOp7LbOGAX83bsKuzDrmC18SA@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I could offer you a net3380 usb gadget device (mini pcie or pcie) but
the uPD720200 is my notebook, so I cannot afford an extra one for you
:)

On Mon, Sep 1, 2014 at 2:25 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> On 09/01/2014 02:19 PM, Ricardo Ribalda Delgado wrote:
>> Do you have a NEC/Renesas uPD720200 USB 3.0 Host?
>>
>> If so, try with an usb gadget acting as a mass storage. That hits the
>> bug in my machine.
>>
>
> Thanks for the tip, but currently I only got Intel hosts.
>
> btw I earlier meant to say that I _don't_ know what's going on yet.
>
> -Mathias
>
>



-- 
Ricardo Ribalda
