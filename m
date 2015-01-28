Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbbA1Bb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:31:28 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:51105 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760371AbbA1Bb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:31:26 -0500
Message-ID: <54C83C21.5080707@physik.fu-berlin.de>
Date: Wed, 28 Jan 2015 02:32:17 +0100
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3.10 06/32] scripts/recordmcount.pl: There is no -m32
 gcc option on Super-H anymore
References: <20150128012627.081285723@linuxfoundation.org> <20150128012627.996535068@linuxfoundation.org>
In-Reply-To: <20150128012627.996535068@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 92.200.48.82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 02:26 AM, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> 
> commit 1caf6aaaa47471831d77c75f094d4e00ad1ec808 upstream.
> 
> Compiling SH with gcc-4.8 fails due to the -m32 option not being
> supported.

JFTR, I didn't test with earlier kernels than 3.18 yet but I assume
earlier versions will just compile fine as well.

Here's the log of a successful build of 3.18 with the patch applied:

>
http://buildd.debian-ports.org/status/fetch.php?pkg=linux&arch=sh4&ver=3.18.3-1~exp1&stamp=1422284071

Thanks for merging.

Cheers,
Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
