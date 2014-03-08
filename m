Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaCHAgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:36:55 -0500
Received: from nm23-vm2.bullet.mail.gq1.yahoo.com ([98.136.217.81]:20726 "EHLO
	nm23-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbaCHAgy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:36:54 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 733228.10658.bm@omp1055.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EES70YK2IXyS9XNwmbUGZlG9VoOJa+IcPhXpOmIliFA8OUt8fDQZxyjQombGzEtKUdjKYlIFSoDPYm+/VzmbzI3+hW4coMdsrHRs26l1LDJbjGFkBLgLlhhBRysAoegtTugVgSaiSE8FfHEVE91+LqsMPG51jCufleEuolYxazg=;
X-YMail-OSG: AgTjnkAVM1nxmEI51B3aKDTzD5AyU5DXc.PXehWUzIvrGTY
 xWHMLDkIEtI3byHjHh7XmzRrlWtpanO8g7mGvlB5uop5AOEj8AMK5sJQ47zV
 W6WVR3qFyN6X7REQecj.T78ig8IguYBcJKVb_Tqh64jKLN2jFBXuXT8HOv99
 SqV1k8J6HBXJ9p58nqpbNEoWd5F1WT8Zmquhge3_IRx.5hW79AUlxkplC8OQ
 m8SLGk4bFevNPvrwdk8kvG13RlZzNIMwIMp..VASEcBnGxoZ17EdnRLL_uQc
 T.ra1vHdDHsFmQ0KFJsfVusW0DFT0MyioQ_wnhLNPiWre5GT4vFELQABYjoH
 oN_n7_cRqgYAEZJXe8pp_yeyCbjGIWRWfoDou9LzUboXPNA.Qz9xNW.6c16Q
 iz8Di18TWWZUL4NvwP6gnaKuA765tHlEgjXLEAmKACvhvibclN5hgE7Bx7mk
 Q30d567JeZHb6lEFLfju6Kym6.btUeNjqn_Mkhry16ScUsUMlOC4yznlaxCX
 thSV65D9bEttqB_oeKg5SsfXEEgDHhig-
X-Rocket-MIMEInfo: 002.001,Pk9uIEZyaWRheSwgTWFyY2ggNywgMjAxNCAxMTozOCBBTSwgSGFydGxleSBTd2VldGVuIDxIYXJ0bGV5U0B2aXNpb25lbmdyYXZlcnMuY29tPiB3cm90ZToKCj4.T24gRnJpZGF5LCBNYXJjaCAwNywgMjAxNCAxOjM4IEFNLCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.VGhpcyBwYXRjaCBmaXhlcyB0aGUgcmVnaXN0ZXIgbWFwIGRlZmluZXMgZm9yIHRoZSBjb3VudGVyIHJlZ2lzdGVycyBzdWNoCj4.dGhhdCB0aGV5IGFyZSBhbGwgdGhlIHJlYWwgb2Zmc2V0cyB0byBlYWNoIHJlZ2lzdGVyLCByYXRoZXIgdGgBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com> <1394181476-17153-1-git-send-email-chase.southwood@yahoo.com> <DC148C5AA1CEBA4E87973D432B1C2D8825DA712C@P3PWEX4MB008.ex4.secureserver.net>
Message-ID: <1394239013.11834.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Fri, 7 Mar 2014 16:36:53 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v2 5/5] Staging: comedi: addi-data: tidy up counter register map defines in hwdrv_apci1564.c
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825DA712C@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, March 7, 2014 11:38 AM, Hartley Sweeten <HartleyS@visionengravers.com> wrote:

>>On Friday, March 07, 2014 1:38 AM, Chase Southwood wrote:
>>This patch fixes the register map defines for the counter registers such
>>that they are all the real offsets to each register, rather than a mix of
>>real offsets and adders to those offsets.
>>
>>Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>---
>>
>>2: Simplified commit message, fixed indentation and whitespace damage.
>>I have test applied this patch, it should work now.
>>v2 also fixes several build breakages, and I have compile tested as well.
>>Everything should be fixed.
>
>Chase,
>
>Looks better, the patches apply now.
>
>The register map whitespace is still a bit of a mess. This is what it looks like
>after applying all 5 patches:
>

[snip]

>
>Check your tab settings in your editor. Normal tab spacing is 8 characters.
>It looks like all the defines align properly at column 49 which is one tab after
>the define on this line:
>
>#define APCI1564_TCW_WARN_TIMEBASE_REG(x)    (0x1c + ((x) * 0x20))
>
>Other than that the patches look good.

OK, yeah, for whatever reason my editor was set to 4 space tabs...I suppose
that explains why it looked perfectly aligned to me but horrifying to everyone else.
I have fixed this setting so it shouldn't be a problem going forward.
Everything appears to be properly aligned for real now, in the v3 I am
sending out momentarily.

Thanks,
Chase

>Regards,
>Hartley 
