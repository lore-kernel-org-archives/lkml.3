Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbaKTKUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:20:36 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:25511 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627AbaKTKUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:20:34 -0500
Message-ID: <546DC00B.30509@imgtec.com>
Date: Thu, 20 Nov 2014 07:18:51 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, James Hogan <james.hogan@imgtec.com>
CC: Andrew Bresticker <abrestic@chromium.org>,
        James Hartley <james.hartley@imgtec.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: img-scb: Allow building for MIPS
References: <1416355113-8942-1-git-send-email-abrestic@chromium.org> <20141119000308.GL1739@jhogan-linux.le.imgtec.org> <20141119090728.GA1439@katana>
In-Reply-To: <20141119090728.GA1439@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.100.200.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 11/19/2014 06:07 AM, Wolfram Sang wrote:
> On Wed, Nov 19, 2014 at 12:03:08AM +0000, James Hogan wrote:
>> On Tue, Nov 18, 2014 at 03:58:33PM -0800, Andrew Bresticker
>> wrote:
>>> The SCB is present on IMG SoCs other than the META-based
>>> TZ1090, such as the MIPS-based Pistachio SoC.  Relax the
>>> Kconfig dependency so that it can be built on any MIPS or META
>>> machine.
>>> 
>>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> 
>> Looks good to me.
>> 
>> Acked-by: James Hogan <james.hogan@imgtec.com>
>> 
>> Cheers James
>> 
> 
> Applied to for-next, thanks!
> 

Can't find this one, maybe it wasn't pushed yet?
- -- 
Ezequiel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUbcALAAoJEIOKbhOEIHKi5U4P+gJ/JwXOFFCbWxhA8SQZShWC
Rwx8RSlvhbsOPPc7G596mMu0nfFBQFVBOII1Pw6UByPlUpi5FaLxQtEnxdWYNGbX
nQ7opxx/r0Ml5z5FsNQnBZ8olaoBfzZb1o/yl91cavul8JND1DCiyljAhvFzwRkv
ggnb8e6VY4ezqhYeS7HxNeVVjl+a3VQRHXnRfKYY/yFzVGO8/p1dPEXgm30hbIiK
NW9DoTq7HRkgtPtEJR1/pR0OnRvE3nA7kgi0u5ZUA8zjlzMwDm1Bpn/MQugX/4Lq
bRCbF67AMYDQAbifimZoxG/mlXRXpaKvcS/o4yagoTdXQuWFPNrRZyRvz9fSaGuZ
GD3sE6IGYwhXIP+o6CIHL/6SUPT50+5hGCcuBivwr3fiBw3SzPDJXAG29gUXo0v7
vW4RTV+mouEgJX4YKdjtLaeCdOrru6zwXEVlhpCky8mczAoYFahK2nm7BhL/aC2y
7nrPNLGAaEg0MXuaWwmgBeYqIHkJyf4TAmL2A5uj4kb8zH7QlzyNSa4ETwL1VqkE
krEOjfr6KsQ2YW9MNEUK8S7ti9WB3ezUOQYEOKGn/w6ZAiynzev6YRg+sWyDhsK2
qZ065wYttrSB/ShHagbQbKt+4F+WXEkLl+T72ZNqwj+02G3/cU9i5BjH8XTsPfJu
Qp66n26U/8ynz4N5rafo
=qMRD
-----END PGP SIGNATURE-----
