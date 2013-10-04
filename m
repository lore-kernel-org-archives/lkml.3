Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3JDRip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:38:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab3JDRil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:38:41 -0400
Message-ID: <524EFCFF.3000003@zytor.com>
Date: Fri, 04 Oct 2013 10:38:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH] Remove redundant and incorrect memset()
References: <20131003131054.GB27835@gmail.com> <1380902566-30867-1-git-send-email-roy.franz@linaro.org> <20131004173310.GA15689@gmail.com>
In-Reply-To: <20131004173310.GA15689@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 10:33 AM, Ingo Molnar wrote:
> 
> * Roy Franz <roy.franz@linaro.org> wrote:
> 
>> Remove a redundant memset() call from efi_relocate_kernel() that
>> was clearing memory that would be used by BSS in non-compressed
>> images loaded with this function.  This clear was redundant with
>> the clearing done in the image itself, and also implemented incorrectly
>> with a 0 length.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> Acked-by: Mark Salter <msalter@redhat.com>
> 
> Note the title:
> 
>    [PATCH] Remove redundant and incorrect memset()
> 
> if it's both redundant *and* incorrect then the other memset() must be 
> incorrect too and must be removed as well ;-)
> 
> I suspect you wanted the title to say:
> 
>    [PATCH] Remove redundant memset()
> 

And more importantly:

[PATCH] boot,efi: Remove redundant memset()

