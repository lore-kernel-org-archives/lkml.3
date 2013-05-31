Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3EaVW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:22:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62082 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab3EaVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:22:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH] pcie-gadget-spear: fix error return code in spear_pcie_gadget_probe()
Date: Fri, 31 May 2013 23:22:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
References: <CAPgLHd8ULtaP23U96nygh-Sr6ySS4-aOuuK3NkvGz1bGj8Dh_A@mail.gmail.com>
In-Reply-To: <CAPgLHd8ULtaP23U96nygh-Sr6ySS4-aOuuK3NkvGz1bGj8Dh_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305312322.14437.arnd@arndb.de>
X-Provags-ID: V02:K0:YgAycPwDQsFm7tvBwYoHZf+MaK48ErjAzRoMWNlJ8eE
 5cvBG9jK0WWHfIIg+Z3kUJfrcebClgJOozK+mosLMJ93Lz2OX6
 YT2pvyRi9K/f0xKdXMUSEPH33VBXgTDmVx1FPLTLf+LuoltDAc
 cu78PDt0Si7uOnAOwvT0a7vc4uKlmNuNEU2la6cuYmZWt+j8bI
 1iwj/I/S+99Ed1/9gnPtk5With9zVZcDVCVL6kj7jINaHXY6qx
 Ta6CrWWNdjuH4m7i+S/7YGVyBJY4viSRPVdMQ5vNBPZB4gVAxp
 GPUB+xsF4HtEjfzxOtXKnios+XhmNzHADx+mTf12aeT9Km1heH
 noNMNl5aTZeQa2XT2zgU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013, Wei Yongjun wrote:
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code in the clk_get_sys() and clk_enable()
> error handling case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The patch seems ok, but since you seem to have run this, would you mind
also sending a patch that gets the driver to actually compile?

	Arnd
