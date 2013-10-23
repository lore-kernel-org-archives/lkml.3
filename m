Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3JWJm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:42:29 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:46236 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3JWJm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:42:27 -0400
Message-ID: <526799B6.1090904@mm-sol.com>
Date: Wed, 23 Oct 2013 12:41:10 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>
CC: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] hwrng: msm: Add PRNG support for MSM SoC's
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com> <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 05:11 PM, Stanimir Varbanov wrote:
> This adds a driver for hardware random number generator present
> on Qualcomm MSM SoC's.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>

Hi Matt, Herbert,

Sorry for the noise but this patch staying for a while in mailing list
and I'd like to get some attention to this driver. Do you think it needs
another re-spin or it has obvious issues / concerns?

Thanks for your time.

regards,
Stan


