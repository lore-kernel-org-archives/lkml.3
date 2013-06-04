Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab3FDBrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:47:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60030 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab3FDBru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:47:50 -0400
Message-ID: <51AD4A34.6050606@windriver.com>
Date: Tue, 4 Jun 2013 10:00:20 +0800
From: Xufeng Zhang <xufeng.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5 ThunderBrowse/3.3.5
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <nhorman@tuxdriver.com>, <vyasevich@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH] sctp: set association state to established in dupcook_a
 handler
References: <1370245978-12884-1-git-send-email-xufeng.zhang@windriver.com> <20130603142811.GE7024@kroah.com>
In-Reply-To: <20130603142811.GE7024@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 10:28 PM, Greg KH wrote:
> On Mon, Jun 03, 2013 at 03:52:58PM +0800, Xufeng Zhang wrote:
>    
>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>>      
> Really?  What are you going to do with it if no one objects?
>    
Sorry, I don't have any experience with stable patch and I consult
stable_kernel_rules.txt, there are not much special rules and here I just
want to specify the kernel version I wish it to be applied to.

> I know I'm sure not going to do anything with it...
>
> (hint, this isn't how you ask for networking stable patches to be
> applied.)
>    
Ok, thanks for your hint, I'll resend the patch.


Thanks,
Xufeng
> greg k-h
>
>    

