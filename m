Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbbALK5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:57:00 -0500
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:23677 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbALK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:56:58 -0500
X-ME-Helo: beldin
X-ME-Date: Mon, 12 Jan 2015 11:56:57 +0100
X-ME-IP: 109.222.243.71
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: [PATCH 3.16.y-ckt 053/168] ARM: pxa: fix hang on startup with DEBUG_LL
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
	<1418653622-21105-54-git-send-email-luis.henriques@canonical.com>
	<1421015948.19708.34.camel@decadent.org.uk>
	<20150112100943.GA2455@charon>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 12 Jan 2015 11:56:56 +0100
In-Reply-To: <20150112100943.GA2455@charon> (Luis Henriques's message of "Mon,
	12 Jan 2015 10:09:43 +0000")
Message-ID: <878uh8z2pz.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques <luis.henriques@canonical.com> writes:

> On Sun, Jan 11, 2015 at 10:39:08PM +0000, Ben Hutchings wrote:
> Thanks Ben.
>
> Robert, do you think this is a problem?  I can revert this patch as
> it has already been released in 3.16.7-ckt3.
Hi Luis,

No, no problem. It'll be an unused kconfig variable, that's all, as
debug_ll_io_init() is not called in v3.16 in pxa_map_io().

Cheers.

--
Robert
