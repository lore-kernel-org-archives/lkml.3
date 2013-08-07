Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab3HGIEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:04:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40643 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3HGIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:04:21 -0400
Date: Wed, 7 Aug 2013 09:02:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bo Shen <voice.shen@atmel.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] clock: correct the comparison parameter of MHz
Message-ID: <20130807080253.GE23006@n2100.arm.linux.org.uk>
References: <1375861660-32525-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375861660-32525-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 03:47:40PM +0800, Bo Shen wrote:
> correct the comparison parameter of MHz from 4,000,000 to 1,000,000

You're assuming this wasn't intentional.  As the division by 1000000
ends up losing the fractional rate, I decided to leave 1-4MHz as kHz,
so something like 1.832MHz would be displayed as 1832kHz and not
1MHz.
