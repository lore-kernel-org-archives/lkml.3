Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab3CMRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:25:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41978 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3CMRZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:25:25 -0400
Message-ID: <5140B674.8070308@zytor.com>
Date: Wed, 13 Mar 2013 10:25:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com> <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410> <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com> <513911F9.8050308@zytor.com> <20130311211750.GB8440@thinkpad-t410> <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com> <20130312211417.GC16558@thinkpad-t410> <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com> <20130313170724.GB12157@thinkpad-t410>
In-Reply-To: <20130313170724.GB12157@thinkpad-t410>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 10:07 AM, Seth Forshee wrote:
>>
>> Granted, this change does mean that your decision at compile time may be
>> final, and you can't enable the pstore code at runtime if you built your
>> kernel/efivars module with CONFIG_EFI_VARS_PSTORE=n. Arguably, I think
>> that's a feature that some people will want, e.g. "Don't allow enabling
>> the efivars pstore backend at all... no, srsly!".
> 
> Hmm. Since my original patch was to compile pstore support out
> completely, I interpreted Peter's suggestion to be allowing the user
> override the default even if the default is disabled. That's the
> assumption my implementation was based off of, but maybe I
> misunderstood.
> 
> But if Peter agrees with your changes then I'm fine with them too.
> 

I think there should be two compile-time options (one to compile in the
EFI pstore code at all, and one to set its default.)

	-hpa

