Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaF3QQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaF3QQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:16:51 -0400
Message-ID: <53B18D69.4020008@redhat.com>
Date: Mon, 30 Jun 2014 11:16:41 -0500
From: Ken Cox <jkc@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, benjamin.romer@unisys.com,
        david.kershner@unisys.com, sparmaintainer@unisys.com,
        devel <devel@driverdev.osuosl.org>, gregkh@linuxfoundation.org
Subject: Re: randconfig build error with next-20140630, in drivers/staging/unisys/channels/chanstub.c
References: <CA+r1ZhjS1T6gHZRur8m4gm-=izvQTBGny2ivynzLY2jqJaevsw@mail.gmail.com>
In-Reply-To: <CA+r1ZhjS1T6gHZRur8m4gm-=izvQTBGny2ivynzLY2jqJaevsw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/30/2014 11:13 AM, Jim Davis wrote:
> Building with the attached random configuration file,
>
> drivers/built-in.o: In function `channel_mod_init':
> chanstub.c:(.init.text+0xcbcf): undefined reference to `unisys_spar_platform'
> make: *** [vmlinux] Error 1
Hi Jim,

I have already submitted a patch to correct this. The kbuild test robot 
uncovered it also.

Thanks for the report,
Ken
