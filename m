Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169Ab3GSNSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:18:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3GSNSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:18:02 -0400
Message-ID: <51E93C7D.9070709@ti.com>
Date: Fri, 19 Jul 2013 18:47:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 0/4] Add phy support for AM335X platform using Generic
 PHy framework
References: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 19 July 2013 06:04 PM, George Cherian wrote:
> This patch series adds phy support for AM335X platform.
> This patch series is based on Generic PHY framework [1].

There are some comments on the generic PHY framework. So you might have to
adapt it once those comments are fixed.

Thanks
Kishon
