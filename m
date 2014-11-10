Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaKJKtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:49:36 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53409 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbaKJKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:49:34 -0500
Message-ID: <1415616570.4862.37.camel@x220>
Subject: Re: ARM: sti: SOC_STIH407 and STIH407_RESET?
From: Paul Bolle <pebolle@tiscali.nl>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 11:49:30 +0100
In-Reply-To: <54609304.4080209@st.com>
References: <1415614934.4862.22.camel@x220> <54609304.4080209@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 10:49:31.0194 (UTC) FILETIME=[01E2C9A0:01CFFCD4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Mon, 2014-11-10 at 11:27 +0100, Maxime Coquelin wrote:
> The STiH407 reset has been merged in Philipp Zabel Reset tree for v3.19:
> http://git.pengutronix.de/?p=pza/linux.git;a=shortlog;h=refs/heads/reset/for_v3.19

That tree isn't part of linux-next, is it? Is it included in a tree that
itself is included in linux-next, so that it will end up in linux-next
one of these days?


Paul Bolle

