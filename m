Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab3CGWRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:17:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab3CGWRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:17:42 -0500
Message-ID: <513911F9.8050308@zytor.com>
Date: Thu, 07 Mar 2013 14:17:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>  <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410> <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 02:15 PM, Matt Fleming wrote:
>>>
>>> What about a command line option?
>>
>> That could be done. I'm assuming you want this instead of a config
>> option, defaulted to on?
>>
>> How would you feel about a config option for the default value of the
>> command line option? I intend to default this to off in Ubuntu for a
>> while as a colleague's machine was recently bricked on two different
>> occasions after the kernel oopsed. The config option would simplify
>> things a bit for us, though we could always carry a patch changing the
>> default value.
> 
> Not sure why a command line option would be a more natural solution to
> this problem? The original patch looked fine to me. All other pstore
> backends are guarded by Kconfig options.
> 
> Though I could see an argument for a kernel parameter to turn off the
> EFI pstore backend code, even if it's compiled into the kernel. But that
> would be better as an additional patch.
> 

That way it can be enabled if needed, without the user having to build
their own kernel.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

