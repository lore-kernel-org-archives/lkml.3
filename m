Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965758AbaH1KaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:30:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:30895 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934654AbaH1KaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:30:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,417,1406617200"; 
   d="scan'208";a="591060081"
Message-ID: <53FF0765.3050509@intel.com>
Date: Thu, 28 Aug 2014 13:41:41 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com> <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com> <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
In-Reply-To: <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 07:10 PM, Ricardo Ribalda Delgado wrote:
> Perhaps we could apply both patches to current tree and backport mine
> to older kernels?
> 

The already applied patch fixes many other issues than just this one.
backporting it to stable < 3.13 turned out to not be that difficult, stable maintainers
said they can do it themselves.

Stable kernels prefer patches that are already upstream, as Documentation/stable_kernel_rules.txt states:
"- It or an equivalent fix must already exist in Linus' tree (upstream)."

There is no need for the other patch anymore, not upstream nor to stable

-Mathias

