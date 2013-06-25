Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FYGsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:48:08 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:57330 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:48:05 -0400
Date: Tue, 25 Jun 2013 08:48:00 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen@asianux.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [Suggestion] arch: avr32: compiler: compiling tools issue
Message-ID: <20130625064800.GB23182@samfundet.no>
References: <51C90B06.5070802@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51C90B06.5070802@asianux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 25 Jun 2013 11:14:14 +0800 or thereabout, Chen Gang wrote:
> Hello Maintainers:
> 
> With allmodconfig, and set "avr32-linux-gnu-" as cross compiler prefix.
> 
> It will report error:
>   avr32-linux-gnu-gcc: error: unrecognized command line option ‘-mno-pic’
>   avr32-linux-gnu-gcc: error: unrecognized command line option ‘-march=ap’
> 
> The related gcc version:
>   [root@dhcp122 linux-next]# rpm -qf /usr/bin/avr32-linux-gnu-gcc
>   gcc-avr32-linux-gnu-4.7.1-0.1.20120606.fc17.x86_64

Interesting version, 4.7.1.

> Can we say: it is compiler's issue, and I need try to compile the cross
> compiler to test it again ?

I would assume so, I didn't know Atmel finally pushed all the source code to
support avr32-linux from upstream.

I still use a jay old 4.2 based GCC port, which was the last one I used when
working for Atmel.

-- 
mvh
Hans-Christian Egtvedt
