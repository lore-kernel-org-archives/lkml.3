Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3JYN6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:58:43 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:44386 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab3JYN6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:58:41 -0400
Message-ID: <526A78C3.9030002@mm-sol.com>
Date: Fri, 25 Oct 2013 16:57:23 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Matt Mackall <mpm@selenic.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] hwrng: msm: Add PRNG support for MSM SoC's
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com> <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com> <526799B6.1090904@mm-sol.com> <20131023094530.GA21796@gondor.apana.org.au>
In-Reply-To: <20131023094530.GA21796@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

On 10/23/2013 12:45 PM, Herbert Xu wrote:
> On Wed, Oct 23, 2013 at 12:41:10PM +0300, Stanimir Varbanov wrote:
>> On 10/15/2013 05:11 PM, Stanimir Varbanov wrote:
>>> This adds a driver for hardware random number generator present
>>> on Qualcomm MSM SoC's.
>>>
>>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>>
>> Hi Matt, Herbert,
>>
>> Sorry for the noise but this patch staying for a while in mailing list
>> and I'd like to get some attention to this driver. Do you think it needs
>> another re-spin or it has obvious issues / concerns?
>>
>> Thanks for your time.
> 
> Well if the ARM folks are OK with it I'm happy to take them.

Thanks!

Can I add your Acked-by for the driver part patch 2/2?

regards,
Stan
