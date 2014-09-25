Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaIYVgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:36:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:42994 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaIYVgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:36:04 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2 05/12] PM / Domains: Add helper variable np = dev->of_node
References: <1410893339-6361-1-git-send-email-geert+renesas@glider.be>
	<1410893339-6361-6-git-send-email-geert+renesas@glider.be>
Date: Thu, 25 Sep 2014 14:36:01 -0700
In-Reply-To: <1410893339-6361-6-git-send-email-geert+renesas@glider.be> (Geert
	Uytterhoeven's message of "Tue, 16 Sep 2014 20:48:52 +0200")
Message-ID: <7hwq8r9yda.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Maybe a short changelog answering "why?" (just a cleanup), and saying
there are no functional changes.

Otherwise,

Acked-by: Kevin Hilman <khilman@linaro.org>

Kevin
