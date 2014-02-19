Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaBSSBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:01:53 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:53173 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaBSSBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:01:51 -0500
Date: Wed, 19 Feb 2014 19:03:05 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3] clk: return probe defer when DT clock not yet
 ready
Message-ID: <20140219190305.788e537d@armhf>
In-Reply-To: <20140208132446.2A26694003E@smtp1-g21.free.fr>
References: <20140208132446.2A26694003E@smtp1-g21.free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013 19:47:04 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> At probe time, a clock device may not be ready when some other device
> wants to use it.
> 
> This patch lets the functions clk_get/devm_clk_get return a probe defer
> when the clock is defined in the DT but not yet available.

Hi Mike,

Any news about this patch?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
