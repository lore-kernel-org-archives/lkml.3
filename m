Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763296Ab3DDFEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:04:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42571 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763259Ab3DDFEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:04:23 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <515D01CC.2060606@prisktech.co.nz>
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz> <CACRpkdZAtgpfA5rZ_C=eKDDOE9aDm=3k1QDava=EGL2BaoV+0g@mail.gmail.com> <515C9DB7.9000908@wwwdotorg.org> <515D01CC.2060606@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv5 0/7] arm: vt8500: Add support for pinctrl/gpio module
From: Stephen Warren <swarren@wwwdotorg.org>
Date: Wed, 03 Apr 2013 23:04:16 -0600
To: Tony Prisk <linux@prisktech.co.nz>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Message-ID: <cda13d16-0282-4483-bda7-98bb90875c77@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Prisk <linux@prisktech.co.nz> wrote:
...
>Can you just confirm you want:
>
>pinctrl: bcm2835: make use of of_property_read_u32_index()
>
>to be included in the pull with this series. I'll get it sent out once 
>you let me know.

That sounds fine, thanks.


-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
