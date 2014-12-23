Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaLWQp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:45:59 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:57512 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbaLWQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:45:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141210121125.GC23481@x1>
References: <1418175593-23474-1-git-send-email-festevam@gmail.com>
	<20141210094649.GA23481@x1>
	<20141210111925.GP11764@sirena.org.uk>
	<20141210121125.GC23481@x1>
Date: Tue, 23 Dec 2014 14:45:56 -0200
Message-ID: <CAOMZO5DVOojrVoM1X6fRDfoNc50b8nPtv7Bu=rFYGBpXMbkiJQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix platform-device id collision
From: Fabio Estevam <festevam@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        johan@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, Dec 10, 2014 at 10:11 AM, Lee Jones <lee.jones@linaro.org> wrote:

> My train of thought was that the original configuration has not
> changed since 2011.  I guess other regulators have been recently
> introduced.  Very well, applied to -fixes.

Still don't see this patch in linux-next.
