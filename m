Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaD1NW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:22:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:44526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaD1NW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,944,1389772800"; 
   d="scan'208";a="530925188"
Message-ID: <535E58BC.9060004@linux.intel.com>
Date: Mon, 28 Apr 2014 16:33:48 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] xhci: fixes for 3.15-rc usb-linus
References: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com> <20140425163505.GA8382@kroah.com>
In-Reply-To: <20140425163505.GA8382@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 07:35 PM, Greg KH wrote:
> On Fri, Apr 25, 2014 at 07:20:12PM +0300, Mathias Nyman wrote:
>> Hi Greg
>>
>> Second try at this xhci fixes series for 3.15-rc usb-linus.
>> Most of them are very small fixes that didn't make
>> it to 3.14, sitting and waiting for 3.15-rc1 to come out.
>>
>> Only the "Prefer endpoint context.." patch  by Julius has a bit more content.
>>
>> These patches are picked together with Sarah, they are tested on top of
>> 3.15-rc1, and apply on your current usb-linus branch
>
> Much better, all now applied.
>
> What's with all that trailing whitespace in your email text?
>

Thanks for applying, and sorry about the whitespace errors.
Did some copy-pasting between editors without proper whitespace 
detection set on all file types.

I'll be more careful with these in the future

-Mathias
