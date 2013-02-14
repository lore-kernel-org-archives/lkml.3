Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684Ab3BNXLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:11:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389Ab3BNXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:11:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/9] ARM: omap: add include guard for soc.h
Date: Thu, 14 Feb 2013 23:11:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-5-git-send-email-arnd@arndb.de> <20130214225526.GH11362@atomide.com>
In-Reply-To: <20130214225526.GH11362@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302142311.44619.arnd@arndb.de>
X-Provags-ID: V02:K0:HPn+U1YMKd3cS3hxzIMMjkTPt8YvQnFInsMrr04Orvj
 h8Ht7Xh4Vo+tsfJiyE0W/rt2MlsMDxwqZ77aqn9gE+9cJ6LCG9
 8obGrQ52hbXHlksBK83mgZE8g0kIPbnGyOacWFNUx/ccMZ3T+V
 S8ai92SvWN1FJHQKboZ1Uf/BxUrTtwMCXoTbVBKl6C6K3jCiKD
 i6eAUqIsM1JaMQhhd8vX4CeSJC5KO63GaMCmpdIQ6XRUhVt5TM
 HdkjYyJGoH4gDdR98xETtpOQPc6+lJODcHgCq9KTqknip3gBra
 ObUjnhD4+8nxogE20k7PvOnxj8XRrVRXtETfCruKW5nNaqZwNw
 XlqiKEyri2eDlOv0PMpM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Tony Lindgren wrote:
> I left it out intentionally as these are private to mach-omap2,
> and I'd like to simplify the indirect includes there further.
> So I'd rather just remove the duplicate soc.h from drm.c.
> 
> If people really think this should be applied, I have no
> objections to this patch naturally.

Either way is fine with me.

	Arnd
