Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaDPCsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:48:45 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44576 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaDPCsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <534CFFF5.70801@ti.com>
References: <1397546239-6650-1-git-send-email-realmz6@kernel.org>
	<534CFFF5.70801@ti.com>
Date: Wed, 16 Apr 2014 10:48:42 +0800
Message-ID: <CAMk6uBn9U2BHCW96pQCrUskUFWq5eVGACJNVM7tO84PzLakLyg@mail.gmail.com>
Subject: Re: [PATCH RESEND] video: bf54x-lq043fb: fix build error
From: Steven Miao <realmz6@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Steven Miao <realmz6@kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomi,

On Tue, Apr 15, 2014 at 5:46 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 15/04/14 10:17, Steven Miao wrote:
>> From: Steven Miao <realmz6@gmail.com>
>>
>> include <linux/gpio.h>, drop <asm/gpio.h>
>>
>
> Thanks, queued for 3.15 fixes.
>
> Btw, usually it's good to say in the description what kind of build
> error happens (i.e. copy paste the error).
Thanks. I'll add more description next time.
>
>  Tomi
>
>
-steven
