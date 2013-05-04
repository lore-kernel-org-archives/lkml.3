Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab3EDPzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 11:55:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab3EDPzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 11:55:09 -0400
Message-ID: <51852F3D.5000802@dawncrow.de>
Date: Sat, 04 May 2013 17:54:37 +0200
From: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com> <51770E4E.2040003@dawncrow.de> <20130424094251.GA21850@mudshark.cambridge.arm.com> <5182C480.3080001@dawncrow.de> <5183819E.50308@arm.com> <20130503095547.GD18614@n2100.arm.linux.org.uk> <5183D6C3.8090402@arm.com>
In-Reply-To: <5183D6C3.8090402@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:xBWT9/ZsueQ7MiZDqlnRJ7rlt3K2yR3weje50IOnC92
 OOvaQfgkOXpu16cH+srH2hT+wu1e0Fwcv1nNKob4MhRC3fFazB
 zyBbmumTETwsnML+2by6MSqwqQiD1lXtMu6FdQscNJvBPxKxSJ
 qJ7oawEEAGZgVAvHWcZ08dgjVYXEkUAm9Ivf+s0Bu3BTqREv93
 wxr3Gq/ZTf1ytbp7T/1cHC3ELZ6ZX/J0rtU9sMsybOQ9lrL616
 K9gpI2uQK/bEqJovf0ETGQ5/OYaFXUP0EY2QcgwmI/a7ckx6oJ
 Yr6PKBzuzeNw4K5SOd1va/bZhnXlHN5q5koDQgYQvx7g2ZNNw0
 CTRUmNmrtSMgQb2WovCM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.05.2013 17:24, schrieb Jonathan Austin:
> Hi Russell,
> 
> Thanks for the comments - you're right about the 'switch_tls'
> being more appropriate - needed to take a step back to see that.
> 
> I've got a few questions, added inline.
> 
> André, Assuming I've understood things okay, there's a patch that
> uses Russell's asm stuff (with minor modifications, see the questions)
> and includes the C-world changes too. Perhaps you could see that it
> solves your problem?

I'll test it tomorrow with my test tool and Wine.
FWIW i hacked together a test tool and it's available at https://github.com/AndreRH/tpidrurw-test
