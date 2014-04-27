Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaD0CPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 22:15:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:53600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaD0CPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 22:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,936,1389772800"; 
   d="scan'208";a="520348125"
Message-ID: <535C6851.9050506@intel.com>
Date: Sun, 27 Apr 2014 10:15:45 +0800
From: Xiao Jin <jin.xiao@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, juan.zou@intel.com,
        yanmin.zhang@intel.com, david.a.cohen@linux.intel.com,
        "Zhang, Qi1" <qi1.zhang@intel.com>
Subject: Re: [PATCH] usb_wwan: some improvement on write and resume
References: <1398387435-13829-1-git-send-email-jin.xiao@intel.com> <20140425091959.GC2206@localhost>
In-Reply-To: <20140425091959.GC2206@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> They are however two distinct bugs and should be fixed separately. Could
> you split the fixes into two patches and resubmit?
>
> Please also include a more descriptive subject line for each patch, for
> example:
>
> 	"USB: usb_wwan: fix urb leak in write error path"
> 	"USB: usb_wwan: fix race between write and resume"
>
> You should probably point out that the write-resume race could also lead
> to writes being reordered in the description of that patch.
>

Thanks. I will resubmit two patches.

Jin

