Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaFXHzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:55:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53359 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbaFXHzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:55:32 -0400
Message-ID: <53A92EEF.6070803@free-electrons.com>
Date: Tue, 24 Jun 2014 09:55:27 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        sergei.shtylyov@cogentembedded.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mvebu: Fix the improper use of the compatible string
 armada38x using a wildcard
References: <1403533011-21339-1-git-send-email-gregory.clement@free-electrons.com> <20140623215309.GD10202@titan.lakedaemon.net>
In-Reply-To: <20140623215309.GD10202@titan.lakedaemon.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

>> This fix should be merged in 3.16 and maybe sent as a fix for 3.15
>> too.

[...]

> Applied to mvebu/dt with Andrew's Ack.

I think it should go mvebu/fixes as this patch modifies the binding,
sooner is better.


Thanks,

Gregory



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
