Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaGTEKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:10:44 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:38550 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaGTEKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:10:43 -0400
Message-ID: <53CB413B.4090409@gmail.com>
Date: Sun, 20 Jul 2014 00:10:35 -0400
From: "Roberto J. Dohnert" <rjdohnert@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Arm Build Failing
References: <CAPDOMVh9knmN1y-LZWvsAKcrKKPQsi0+skNG1D0aQgP+hg3ssQ@mail.gmail.com>
In-Reply-To: <CAPDOMVh9knmN1y-LZWvsAKcrKKPQsi0+skNG1D0aQgP+hg3ssQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like its trying to invoke the native (x86) compiler, but 
passing it options that only make sense to an ARM compiler.

Cheers

Roberto J. Dohnert
Roberto J. Dohnert
Lead Developer
Black Lab Software Inc.
PO Box 698
Franklinton NC 27525
http://www.pc-opensystems.com
http://www.blacklablinux.org

On 07/20/2014 12:03 AM, Nick Krause wrote:
> arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-m64’
> arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-mno-mmx’
> arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-mno-sse’
> arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-mno-red-zone’
> arm-linux-gnueabihf-gcc: error: unrecognized command line option
> ‘-mcmodel=kernel’
> This happens every time I try to build new arch code this week. Is there a easy
> fix for this?
> Cheers Nick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

