Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3H0Vlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:41:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51569 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3H0Vlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:41:46 -0400
Message-ID: <521D1D16.9080106@wwwdotorg.org>
Date: Tue, 27 Aug 2013 15:41:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>
CC: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [RFC][PATCH v2] documentation/devicetree: Move DT bindigns from
 gpio to watchdog
References: <521672A1.6010202@wwwdotorg.org> <1377601837-18989-1-git-send-email-johannes.thumshirn@men.de>
In-Reply-To: <1377601837-18989-1-git-send-email-johannes.thumshirn@men.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 05:10 AM, Johannes Thumshirn wrote:
> I accidently put the devicetree bindings for the MEN A21 watchdog driver in
> Documentation/devicetree/bindings/gpio instead of
> Documentation/devicetree/bindings/watchdog, this patch addresses this error.

>  Changes to v1:
>  - Use named gpios, as suggested by Stephen Warren

The move and the change to the binding should probably be separate
patches since they're logically separate things. I didn't intend you to
update the rename patch to fix the binding issue I pointed out.

Is the driver updated for this binding change? Are there DTs in released
kernels that won't work now, or is the driver very new; there may be a
need for the driver to support the old binding and the binding doc to
document the old gpios property, but mark it deprecated.
