Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3JAQSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:18:43 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60297 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3JAQSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:18:40 -0400
Date: Tue, 1 Oct 2013 09:18:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: johannes.thumshirn@men.de
Cc: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Wim Van Sebroeck <wim@iguana.be>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [RFC, v2] documentation/devicetree: Move DT bindigns from gpio
 to watchdog
Message-ID: <20131001161835.GA14449@roeck-us.net>
References: <1377601837-18989-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377601837-18989-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 07:10:37PM -0000, johannes.thumshirn@men.de wrote:
> I accidently put the devicetree bindings for the MEN A21 watchdog driver in
> Documentation/devicetree/bindings/gpio instead of
> Documentation/devicetree/bindings/watchdog, this patch addresses this error.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Guenter Roeck <linux@roeck-us.net>
> 
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
