Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaLXP13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:27:29 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46711 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLXP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:27:27 -0500
Message-ID: <549ADB56.7060204@gmail.com>
Date: Wed, 24 Dec 2014 23:27:18 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "jejb@parisc-linux.org" <jejb@parisc-linux.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Joel Brobecker <brobecker@adacore.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox> <54822B19.2070804@gmail.com> <54832761.1050700@gmail.com>
In-Reply-To: <54832761.1050700@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2014 11:57 PM, Chen Gang wrote:
> Hello Maintainers:
> 
[...]
> 
> But for parisc gcc latest upstream compiler, I found several issues, and
> I shall try to analyse them and communicate with gcc related members.
> 

Oh, sorry, there is one my configuration issue when cross compiling
parisc, after give a correct configuration, most of issues are disapear.

Thanks.

[...]
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
