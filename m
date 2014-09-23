Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaIWM5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:57:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:62987 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaIWM5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140923124045.GA13913@sepie.suse.cz>
References: <CAFnufp3DcbG1DjXjD-sTL=1wYzu9dS5r1UXxGQwQjR11zRSBfg@mail.gmail.com>
 <20140923124045.GA13913@sepie.suse.cz>
From: Matteo Croce <matteo@openwrt.org>
Date: Tue, 23 Sep 2014 14:57:07 +0200
X-Google-Sender-Auth: FS0XC35F3-Ylje7K5-yvOAniRKE
Message-ID: <CAFnufp2DQvEywZW0sg-+hLyeDY+L0UwWjEtDwX-PgOJWda-HOw@mail.gmail.com>
Subject: Re: [PATCH] x86 generated files in gitignore
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Didn't know, thanks.

What about arch/x86/purgatory?

Cheers,

2014-09-23 14:40 GMT+02:00 Michal Marek <mmarek@suse.cz>:
> On Wed, Sep 03, 2014 at 10:42:04AM +0200, Matteo Croce wrote:
>> @@ -10,3 +10,4 @@ recordmcount
>>  docproc
>>  sortextable
>>  asn1_compiler
>> +bin2c
>
> bin2c has been moved to scripts/basic, what you see is probably a
> leftover from building an older kernel.
>
> Michal



-- 
Matteo Croce
OpenWrt Developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 BARRIER BREAKER
 -----------------------------------------------------
  * 1/2 oz Galliano         Pour all ingredients into
  * 4 oz cold Coffee        an irish coffee mug filled
  * 1 1/2 oz Dark Rum       with crushed ice. Stir.
  * 2 tsp. Creme de Cacao
 -----------------------------------------------------
