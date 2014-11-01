Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbaKAOv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 10:51:56 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42725 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367AbaKAOvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 10:51:51 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
Date: Sat, 1 Nov 2014 22:51:47 +0800
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Joe Perches <joe@perches.com>, Chen Weixiang <weixiangchen@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that '=',
 '<' and '=='
Message-ID: <20141101145147.GB8194@chenwx>
Mail-Followup-To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Joe Perches <joe@perches.com>,
	Chen Weixiang <weixiangchen@gmail.com>,
	Marek Belisko <marek.belisko@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
	Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
	Daniel Dodge <danieldodgese@gmail.com>,
	Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
 <1414810047-6975-2-git-send-email-weixiang.chen@gmail.com>
 <20141101050535.GC3642@sudip-PC>
 <1414818870.31550.1.camel@perches.com>
 <20141101052501.GH3642@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101052501.GH3642@sudip-PC>
User-Agent: Mutt/1.5.23 (b8a63730c848) (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:55:01AM +0530, Sudip Mukherjee wrote:
> ok, just to verify, i thought of trying to generate a similar patch which will not give checkpatch errors.
> but this patch is not applying to next-20141031.
> 
> thanks
> sudip

Hi sudip,

It's my fault that I'm not fetching latest tags on linux-next before
checking the code style errors. Please ignore this patch, sorry.

-- 
Best regards,
Chen Weixiang (Alex)

