Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaBLNSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:18:47 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33999 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751397AbaBLNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:18:46 -0500
Date: Wed, 12 Feb 2014 13:18:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fabrice GASNIER <fabrice.gasnier@stericsson.com>
Cc: Fabrice GASNIER <fabrice.gasnier@st.com>, u.kleine-koenig@pengutronix.de,
        jonathan.austin@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        nico@linaro.org, sboyd@codeaurora.org, marc.zyngier@arm.com,
        ben.dooks@codethink.co.uk, vgupta@synopsys.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com
Subject: Re: [PATCH v2] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140212131834.GP26684@n2100.arm.linux.org.uk>
References: <1392050756-11145-1-git-send-email-fabrice.gasnier@st.com> <52FB71A3.5010505@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB71A3.5010505@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 02:05:39PM +0100, Fabrice GASNIER wrote:
> Hi,
>
> Any comments on this patch ?
>
> Russell, can I add this patch to your patch tracker system ?

I don't see how this works on anything but ARMv7M.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
