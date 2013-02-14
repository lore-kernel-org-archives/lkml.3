Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416Ab3BNBeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:34:18 -0500
Received: from nm20.access.bullet.mail.sp2.yahoo.com ([98.139.44.147]:22739
	"EHLO nm20.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761430Ab3BNBeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:34:16 -0500
X-Yahoo-Newman-Id: 454098.47217.bm@smtp108.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 77G_lAwVM1mkxWXJhePq3tvrbacD0rGfa7jNqDTHcueEtYK
 gCttLztFlSvsxhMrfdSVLDF0Fo7j4ZHcF5bR0zpX1lIh8k_tV5r97WvrUvOT
 XtyzHecqjK.9hBJKeu9dFxO4_ydaGJbGU9r7JM1EcnOcpZcMjxQkcWiRAFmF
 o_zsmImzl.xGNczLYkKXaxkzKs_8ZTx1tFTvq7j3Yecs.BCvLDW72p44ROQj
 TRZniGFtP668Yg5Qpii0j4uNNODwLz_IR72yPl80iXWPcQ8v_d2mfRBt3v.8
 UFfK6aNzZgQclH_rCmSQYR8_OvQHKoT6vf4bLPT3eUkR.pDzSHkuOcfPgEdt
 uoX8m9HNcIYKITbpj9qHBFPVwqjH571wt6ASldI.L.lT1Muik.qQnpD.Fm0s
 kI7tuQPoR3nxnViFgweuQqJiplWOn9nOSX8wTZeTEOY921xJsQ197QuqwZfl
 0A2PrVXzBBExW_rXajo.empM-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <511C3F2C.9040403@schaufler-ca.com>
Date: Wed, 13 Feb 2013 17:34:36 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>       <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>       <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>       <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>       <1360373383.18083.23.camel@x230.lan>       <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>       <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>      <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>     <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>    <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>   <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>  <511BD291.1040003@schaufler-ca.com> <511C1325.5060601@zytor.com>  <511C1A94.8020804@schaufler-ca.com> <511C2F0C.3060803@zytor.com >  <511C3389.5090604@schaufler-ca.com> <1360803872.18083.46.camel@x230.lan>
In-Reply-To: <1360803872.18083.46.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/2013 5:04 PM, Matthew Garrett wrote:
> On Wed, 2013-02-13 at 16:44 -0800, Casey Schaufler wrote:
>
>> If you want that sort of granularity throw yourself on the SELinux
>> bandwagon. Fine grained capabilities are insane and unmanageable
>> and will only lead to tears. Security is despised because of the
>> notion that making systems impossible to use is a good thing.
> SELinux is completely unusable for this specific case.
>
Well, you'll get no argument from me there.

