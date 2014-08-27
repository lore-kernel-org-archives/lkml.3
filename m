Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024AbaH0PPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:15:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:40457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934963AbaH0PPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,411,1406617200"; 
   d="scan'208";a="564189957"
Message-ID: <53FDF8D9.60103@intel.com>
Date: Wed, 27 Aug 2014 18:27:21 +0300
From: Mathias Nyman <mathias.nyman@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com> <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
In-Reply-To: <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 05:14 PM, Ricardo Ribalda Delgado wrote:
> At least I have seen the issue on Debian 3.14 and 3.16. Is your patch
> going to be backported to linux-stable? The computer crashes very very
> badly
> 

Yes, it is, but it might need some additional work as it won't apply cleanly on older versions

http://marc.info/?l=linux-usb&m=140913688327011&w=2

-Mathias
