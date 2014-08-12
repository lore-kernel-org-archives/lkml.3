Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaHLRO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:14:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:40308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaHLRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:14:27 -0400
Message-ID: <53EA4B6E.9000500@infradead.org>
Date: Tue, 12 Aug 2014 10:14:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>
Subject: Re: make mandocs error with next-20140812
References: <CA+r1Zhip1SZww=sueoRJD=ZzekqLJjeY7O461wnFVRdsuz+eWg@mail.gmail.com>
In-Reply-To: <CA+r1Zhip1SZww=sueoRJD=ZzekqLJjeY7O461wnFVRdsuz+eWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 10:12, Jim Davis wrote:
> docproc: .//drivers/gpu/drm/drm_stub.c: No such file or directory
> make[1]: *** [Documentation/DocBook/drm.xml] Error 1
> make: *** [mandocs] Error 2
> --

Known and patch has been submitted.  I'll try to get it merged.

-- 
~Randy
