Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3IRTiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:38:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59053 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3IRTiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:38:02 -0400
Message-ID: <523A0115.2080302@wwwdotorg.org>
Date: Wed, 18 Sep 2013 13:37:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/26] ARM: bcm2835: remove custom .init_time hook
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-11-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 11:53 AM, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks. Also remove call to of_clk_init from
> clk-bcm2835 with core fixed_clock match, as this has already been
> registered now.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

