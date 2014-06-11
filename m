Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaFKIIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:08:21 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62086 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaFKIIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:08:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-i2c@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface) controller support
Date: Wed, 11 Jun 2014 10:07:04 +0200
Message-ID: <5138962.eWJk3tfacf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53980AD4.2080001@free-electrons.com>
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com> <13219561.hrRmVFjmAv@wuerfel> <53980AD4.2080001@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WUt1Arv4Aw9qRl5qQlkg/b9Hd+eYiwAcn2zYTDqNbZe
 g8cqO0ZOUhY0egwJrs0WK48DDqaj9GdDNMQHdEdNLWC/FgSfUP
 6/wZwm9tlDMBp9XAw4jtfNCqBb6rpBXFjB2R9Ky+mcIi3wuef6
 6nSUSamz6H5ZJmdKyoUdlpEqrjLMjsWwWmIWfYVM5fSaLyuvWW
 wFVWr0bXg/JTQQmGsWtzyekUjQKZWApWfp619GLZoJSXnWgyxG
 jgopfhs+KQ1UrDjBeBLA1LhtcRp/zu1UQX6fVj9iyyixt5SY9U
 eTX6sGik0c+qhl1X3VkNGP2NbNxm9upz8epIGx27IP4aGuuiN9
 wkE5fnmeBJ5uaeKwLVXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2014 09:52:52 Boris BREZILLON wrote:
> You mean in my commit message ?
> I thought it was already explaining the subtle differences between P2WI
> and the SMBus protocols.
> 
> What would you like me to add to this explanation ?
> Something about the I2C to P2WI initialization part ?
> 

What I'd like to see is a mention of previous discussion that
concluded that it should be an i2c driver rather than a new
type of driver, and why.

	Arnd
