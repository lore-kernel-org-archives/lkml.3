Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbaKAOJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 10:09:46 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48571 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbaKAOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 10:09:44 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
Date: Sat, 1 Nov 2014 22:09:39 +0800
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Chen Weixiang <weixiangchen@gmail.com>,
        Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] staging: ft1000: spaces required around that '=',
 '<' and '=='
Message-ID: <20141101140939.GA8194@chenwx>
Mail-Followup-To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101050535.GC3642@sudip-PC>
User-Agent: Mutt/1.5.23 (b8a63730c848) (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:35:35AM +0530, Sudip Mukherjee wrote:
> many whitespace errors in the patch.
> checkpatch gives total: 8 errors, 23 warnings, 125 lines checked
> 
> thanks
> sudip
> 

Hi sudip,

Yes, I also run checkpatch.pl on this patch, and got several
errors/warnings. But those errors/warnings are not related to
spaces around '=', '<' and '==' anymore.

I thought it's better to fix one code style error/warning in
one patch, and put the code style error/warning to Subject line.
It's much clear, isn't it?

Thanks.

-- 
Best regards,
Chen Weixiang (Alex)

