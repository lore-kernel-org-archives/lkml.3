Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaIAKXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:23:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:44705 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbaIAKXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:23:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,441,1406617200"; 
   d="scan'208";a="566519505"
Message-ID: <54044C5C.9010305@intel.com>
Date: Mon, 01 Sep 2014 13:37:16 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com> <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com> <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com> <53FF0765.3050509@intel.com> <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com> <CAPybu_1UytoxXk-t7u_3vQ6KL-5DmVUz1u5PiDLysBCvgit--A@mail.gmail.com> <53FF48B1.5090901@intel.com> <CAPybu_2rgn-DEUKfdmGsaAsFSQJ_zz6fsdnD0dHmyCPW4B-+WA@mail.gmail.com> <54009A50.9010707@intel.com> <CAPybu_2ZQ9iPA_FfYn2Mqg5vXn40HuFCcVv1Zg900YavKCDxUQ@mail.gmail.com> <CAPybu_3qmtob-uJhcUwEETcM7cXPxOm3-zOjNFLub31mQDdABQ@mail.gmail.com>
In-Reply-To: <CAPybu_3qmtob-uJhcUwEETcM7cXPxOm3-zOjNFLub31mQDdABQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 12:36 PM, Ricardo Ribalda Delgado wrote:
> After some time of use (one hour or so) my system started to behave
> "weird". I did check  dmesg and I was receiving the following line
> again and again:
> 
> usb-storage: Error in queuecommand_lck: us->sfb= ffff8805bd61ccc0
> 
> I did disconnect the usb device and the whole computer crashed :S
> 

Ok, thanks.

Would you say things work better after the patch?

I still think the patch solves part of the issue, i.e. how we handle halted endpoints
in reset, but I don't know the reason why the endpoints stall in the first place

-Mathias


