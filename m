Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162641AbaDCI1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:27:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:64138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162618AbaDCI1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:27:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,785,1389772800"; 
   d="scan'208";a="513948009"
Message-ID: <533D1E03.8080101@linux.intel.com>
Date: Thu, 03 Apr 2014 11:38:27 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: "Nyman, Mathias" <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: xhci: Prefer endpoint context dequeue pointer over
 stopped_trb
References: <1392959535-29654-1-git-send-email-jwerner@chromium.org>	<20140228205358.GA5340@xanatos> <CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>
In-Reply-To: <CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 04/03/2014 12:29 AM, Julius Werner wrote:
> Hi Mathias,
>
>> The patch looks fine.  Mathias is taking over for xHCI driver
>> maintainership in 3.15.  He's currently handling queuing bug fix patches
>> for 3.14 while I finish queueing feature patches for 3.15.  Mathias,
>> will you test and queue this up for 3.14?
>
> Did you pick this patch up anywhere yet or are there still issues with
> it? I just want to make sure it doesn't slip through the cracks.
> (Maybe I just didn't see it yet... are you still queueing patches in
> sarah/xhci.git or do you have your own repository somewhere?)

Patch applies fine and I'll send it forward to Greg once 3.15-rc1 is out.

I'm not using Sarah's tree, but setting up my own tree on kernel.org 
(Just got access). I got a temporary one on github if you want to take a 
look, but it's a short term thing and it may change without warning.

git@github.com:matnyman/xhci.git

-Mathias
