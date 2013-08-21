Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3HUReH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:34:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50284 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3HUReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:34:04 -0400
Message-ID: <5214FA08.7090502@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:34:00 -0600
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
Subject: Re: [PATCH] documentation/devicetree: Move DT bindigns from gpio
 to watchdog
References: <1377088929-23694-1-git-send-email-johannes.thumshirn@men.de>
In-Reply-To: <1377088929-23694-1-git-send-email-johannes.thumshirn@men.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 06:42 AM, Johannes Thumshirn wrote:
> I accidently put the devicetree bindings for the MEN A21 watchdog driver in
> Documentation/devicetree/bindings/gpio instead of
> Documentation/devicetree/bindings/watchdog, this patch addresses this error.

The rename sounds fine, so that part,
Acked-by: Stephen Warren <swarren@nvidia.com>

However, the binding itself doesn't look right; it appears to have a
single "gpios" property rather than using separate named xxx-gpios
properties for different things...

