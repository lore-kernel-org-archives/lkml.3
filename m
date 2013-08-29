Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3H2SrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:47:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3H2SrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:47:05 -0400
Message-ID: <521F9708.6040902@zytor.com>
Date: Thu, 29 Aug 2013 11:46:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 05/10] asus-wmi: Restrict debugfs interface when module
 loading is restricted
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>  <1376928619-3775-5-git-send-email-matthew.garrett@nebula.com>  <521F9162.9060405@zytor.com> <1377801331.27493.17.camel@x230>
In-Reply-To: <1377801331.27493.17.camel@x230>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:35 AM, Matthew Garrett wrote:
> On Thu, 2013-08-29 at 11:22 -0700, H. Peter Anvin wrote:
>> On 08/19/2013 09:10 AM, Matthew Garrett wrote:
>>> +	if (!capable(CAP_COMPROMISE_KERNEL))
>>> +		return -EPERM;
>>> +
>>
>> Stale bits?
> 
> Yeah. Did I manage to send out the old copy of that again? I'm sorry,
> spending a few months concentrating on cloud stuff seems to have
> entirely destroyed my ability to deal with git :(
> 

No, you mixed and matched in a single patch...

I still believe that CAP_RAWIO should be forbidden in this case.

	-hpa

