Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3I3DMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 23:12:40 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:42400 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3I3DMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 23:12:37 -0400
Date: Mon, 30 Sep 2013 03:12:36 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Suman Anna <s-anna@ti.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 0/9] omap hwspinlock dt support
In-Reply-To: <5245A8CA.4020805@ti.com>
Message-ID: <alpine.DEB.2.02.1309300309530.17980@utopia.booyaka.com>
References: <cover.1379445653.git.s-anna@ti.com> <5245A8CA.4020805@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, 27 Sep 2013, Suman Anna wrote:

> Paul,
> The hwmod data patches needs to be merged only after the respective DT
> node patches are merged, without which the hwmod entry will not have a
> base address while enabling and idling (using sysc) the hwmod during
> hwmod initialization.

Hmm, ideally there shouldn't be a merge dependency here. Could you please 
send a patch to the hwmod core that logs a warning and skips the operation 
in these circumstances?  Or maybe just skips the registration of the 
device?


- Paul
