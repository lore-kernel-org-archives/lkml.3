Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3F0J1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab3F0J1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:27:50 -0400
Message-ID: <51CC0566.8010302@redhat.com>
Date: Thu, 27 Jun 2013 11:27:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/26/2013 11:16 PM, Maxime Ripard wrote:
> Hi everyone,
>

<snip>

> It also finally adds a clocksource from the free running counter found in the
> A10/A13 SoCs.

Hmm, have you benchmarked this? There have been reports from linux-sunxi kernel
users (xbmc project) that the waiting for the latch is quite slow. Note we
don't have anything better yet in the linux-sunxi kernel.

Regards,

Hans
