Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaFWNr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:47:58 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28769 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754316AbaFWNrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:47:55 -0400
Message-ID: <1403531263.3804.6.camel@hornet>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
From: Pawel Moll <pawel.moll@arm.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 23 Jun 2014 14:47:43 +0100
In-Reply-To: <53A809D4.90800@ti.com>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
	 <53A809D4.90800@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 14:04 +0300, Tomi Valkeinen wrote:
> I can queue this to fbdev tree, but how do you want to handle the second
> patch? I think these two patches are independent, so the second patch
> could go via arm-soc tree (or whichever is the normal route for those
> .dts file changes). I'd prefer that option.

That's exactly what I had on mind. I'll handle the dts changes when the
time is right.

Thanks!

Pawel

