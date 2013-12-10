Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3LJWRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:17:04 -0500
Received: from smtp-out.abv.bg ([194.153.145.99]:52676 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3LJWRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:17:01 -0500
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=ij4KUGdshbcvEMkKhsxwosmMWOzjYe8/1/TFB2PVl4D09EPEO24kjeL1J1a+LoXTD
	BD+5NxxyLh37bXVVHgwD5u68hKpFP4XNYILvLHfMRA9fhIyYzpKimGdJyN25viPPvZH
	niSTYN97oIA+5vZMO3k2ehSYWoSLWa2Ad22YptA=
Date: Wed, 11 Dec 2013 00:16:58 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: kvalo@adurom.com, pavel@ucw.cz, luca@coelho.fi, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aaro.koskinen@iki.fi, sre@ring0.de,
        joni.lapilainen@gmail.com, johannes@sipsolutions.net,
        felipe.contreras@gmail.com, david.gnedt@davizone.at
Message-ID: <1209321878.38095.1386713818964.JavaMail.apache@mail82.abv.bg>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 46.249.74.23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  >-------- Оригинално писмо --------
 >От:  Pali Rohár 
 >Относно: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
 >До: Kalle Valo ,
 Pavel Machek 
 >Изпратено на: Вторник, 2013, Декември 10 19:08:44 EET
 >
 >
 >On Tuesday 10 December 2013 16:41:04 Kalle Valo wrote:
 >> Pavel Machek  writes:
 >> > ssids can have &#92;0s in them... and what is worse, they may
 >> > not be 0 terminated AFAICT.
 >> > 
 >> > Potential solution is at
 >> > http://www.spinics.net/lists/linux-wireless/msg98640.html .
 >> 
 >> I just use print_hex_dump_bytes() to print SSIDs.
 >
 >Ok and has kernel printf modifier for size_t?
 >
 >-- 
 >Pali Rohár
 >pali.rohar@gmail.com
 >

If I read lib/vsprintf.c correctly, you can use 'z'

Regards,
Ivo

PS: Please use my gmail address when cc-ing me, LKML really hates my abv dot bg account :)

