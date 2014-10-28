Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaJ1UB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:01:29 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57668 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJ1UB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:01:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 8/8] ARM: multi_v7_defconfig: Enable Broadcom Cygnus
Date: Tue, 28 Oct 2014 21:01:11 +0100
Message-ID: <5089697.D8odgNlVtY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414525992-3678-9-git-send-email-sbranden@broadcom.com>
References: <1414525992-3678-9-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DaQOpVKLT+O05dAj5ilqSkHB8zODaLSkCQ12hYWBhi9
 k/m0+YkPUqQgK61G1MWACwYYVavsqZgmJQHJ0Wah44FCK24fsQ
 4UBalFTSMb1JJHOhOszxLTo01JQpzgFAv5/3cHA3HzsAvXzcuH
 svAwNcxzRpLambHky57E8RBxX8Ru/eeOAVO6gGiBhO77Maf4c0
 uNfZwFo8fgWzwkcD8Oe8VDkEXxENRN/c/snqEcMnUTzQ8xy8br
 yXtHU6dD48qg/8CBBOz5v8uB+/uQGLcf3u8WnXnsOhSawUC/CL
 hx5OogOMWDKISpS9HxXBKcVZ84xJWPiktq4kIrKc9enNpaaGfc
 8biGxPmk4qvPSKfudlRI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 12:53:12 Scott Branden wrote:
> From: Ray Jui <rjui@broadcom.com>
> 
> Enable Broadcom Cygnus platform support in multi_v7_defconfig
> 
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>
> 

Just to be sure: did you check that multi_v7_defconfig contains
all the drivers you need that you enable in your other defconfig?

	Arnd
