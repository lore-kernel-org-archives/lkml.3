Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3JYO6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:58:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54643 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab3JYO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:58:35 -0400
Message-ID: <526A86F1.6030907@zytor.com>
Date: Fri, 25 Oct 2013 15:57:53 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Add support for Qualcomm's PRNG
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 03:11 PM, Stanimir Varbanov wrote:
> This patch set adds hardware RNG driver wich is used to control the
> Qualcomm's PRNG hardware block.

I still haven't seen anyone address the "P" bit of the "PRNG"... what is
the (guaranteed) entropic level of the output?

	-hpa


