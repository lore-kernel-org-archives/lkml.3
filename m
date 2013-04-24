Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3DXO5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:57:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3DXO5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:57:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 04/10] usb: musb: ux500: harden checks for platform data
Date: Wed, 24 Apr 2013 16:56:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: balbi@ti.com, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        mian.yousaf.kaukab@stericsson.com, linux-usb@vger.kernel.org
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org> <20130424142615.GF23081@arwen.pp.htv.fi> <CAF2Aj3ga7R3Vti4YB-83T_AsanB3iL34aysAN3MiMWZBvB=z2Q@mail.gmail.com>
In-Reply-To: <CAF2Aj3ga7R3Vti4YB-83T_AsanB3iL34aysAN3MiMWZBvB=z2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304241656.53432.arnd@arndb.de>
X-Provags-ID: V02:K0:uZaJaUaomZ4ZgcHm/Drzvh54JIhHTV6q6Xjafnd3dGv
 8GpVtNxVeEpBL49Cl6Hlz7Zr00eR4VLm6+wdx6V6jTZvRDiZQA
 IWN0Qrj0qYFqtUiFxpWfAhkQeFfWYiM4FEuya337DrYBWHzOYR
 lGiFNJwIfW8jdaEvN1O9BV2bELEPtkZCKVS2FxCzq5hVT4Fcdp
 Q9wmDLQVr7K9AvSHQ2rwCaYlB2vl07X59Vbk9VQzqOKJ53NCq4
 TPapLrk/z9OVxpMoJj5mbVXxdgGCbiKd2nXhnprs/h+Na18VrN
 6m3zWV3386GKzieiVGVepGoxaPbCS2lvaS2Tg89QnSzZgZQvjz
 5nLGZN7bPbqaaaJs3nzo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013, Lee Jones wrote:
> Yeah, I agree, although does it make a difference?
> 
> Is it evaluated a second time, or does it take up extra cycles by being
> enclosed in parentheses?
> 
> Or is this just a coding style thing?

Just coding style. I agree you should have no parentheses there, but it
does not change the compiled code.

	Arnd
