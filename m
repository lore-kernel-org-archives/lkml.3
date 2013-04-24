Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3DXCGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:06:38 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34282 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3DXCGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:06:37 -0400
Message-ID: <51773DF8.70509@hp.com>
Date: Wed, 24 Apr 2013 10:05:44 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.vaden@hp.com
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
References: <1366701301-16603-1-git-send-email-zhen-hual@hp.com> <20130423140734.GA30877@kroah.com> <51771F66.3080801@hp.com> <20130424015722.GA1269@kroah.com>
In-Reply-To: <20130424015722.GA1269@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not found any url you can visit. And we will file a bug on SLES 
bugzilla site if possible.

I   paste the bug discription here:
When booting SLES 11 SP2 on our server , messages like the following are 
logged during boot:
[  254.087187] uhci_hcd 0000:07:00.4: Controller not stopped yet!

Thanks
Zhen-Hua

On 04/24/2013 09:57 AM, Greg KH wrote:
> On Wed, Apr 24, 2013 at 07:55:18AM +0800, ZhenHua wrote:
>> On 04/23/2013 10:07 PM, Greg KH wrote:
>>> On Tue, Apr 23, 2013 at 03:15:01PM +0800, Li, Zhen-Hua wrote:
>>>> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
>>>>
>>>> This patch is trying to fix bug QXCR1001261767.
>> Sorry for the bug number. Please ignore this line.
> I don't want to ignore it, I want it to point to something that I, and
> others, can reference in the future.  Is there a url you can use for it?
>
> thanks,
>
> greg k-h

