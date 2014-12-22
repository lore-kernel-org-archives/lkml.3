Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaLVB5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:57:34 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13540 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753647AbaLVB5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:57:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/0X+6PdBt1uNjcNoVp0DQaPIH12HrlgrQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8B3C1636462
Date: Sun, 21 Dec 2014 20:57:29 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: mathieu.poirier@linaro.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fixing various coding style problems
Message-ID: <20141222015729.GE28117@titan.lakedaemon.net>
References: <1419206988-27331-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419206988-27331-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

On Sun, Dec 21, 2014 at 05:09:48PM -0700, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Fixing errors related to the usage of do {} while (0) loop
> in single statement macros, trailing semicolon in macros and
> trailing whitespace.

Huh.  iirc, I added those do {} while(0)s to keep checkpatch happy.
Either it's gotten smarter, or something is off.

At any rate, the whole macro menagerie in here concerns me a bit and I'm
reluctant to change it until I have some time to refresh my memory on
what this code is doing.

It would be helpful if you could give scripts/objdiff a try on the
before and after effects of your patch.  If the object code doesn't
change, then we can be more confident that the patch is just style
changes.  Please also check when SKEIN_UNROLL_* is set/unset.

I really should put the patch series together to move this driver out of
staging.  Then maybe folks will stop running checkpatch against it :-)

thx,

Jason.
