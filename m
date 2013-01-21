Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3AUNvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:51:20 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:42375 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3AUNvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:51:18 -0500
Message-ID: <50FD47CA.5050806@synopsys.com>
Date: Mon, 21 Jan 2013 19:21:06 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 63/76] ARC: Hostlink Pseudo-Driver for Metaware Debugger
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-64-git-send-email-vgupta@synopsys.com> <201301181458.26891.arnd@arndb.de>
In-Reply-To: <201301181458.26891.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 08:28 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> +static int arc_hl_nr_devs = 1;
> This seems to be read-only and hardcoded to 1. If this is true, you could
> simplify the driver significantly by just using misc_register, rather
> than registering your own major device number.
>
> 	Arnd

:-) Indeed virtually there's nothing left in there after misc_register

Thx,
-Vineet
