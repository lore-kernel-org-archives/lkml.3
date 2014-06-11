Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbaFKJMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:12:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60128 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755303AbaFKJMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:12:09 -0400
Message-ID: <53981D66.4020002@free-electrons.com>
Date: Wed, 11 Jun 2014 11:12:06 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Arnd Bergmann <arnd@arndb.de>, Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
References: <1402475980-15513-1-git-send-email-boris.brezillon@free-electrons.com> <1402475980-15513-3-git-send-email-boris.brezillon@free-electrons.com> <20140611085557.GA2676@katana>
In-Reply-To: <20140611085557.GA2676@katana>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/06/2014 10:55, Wolfram Sang wrote:
>> +MODULE_LICENSE("GPL");
> "GPL v2"

Oops, I missed this one.

Sorry for the inconvenience.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

