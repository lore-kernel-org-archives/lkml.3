Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3CMOdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:33:53 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:43092 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556Ab3CMOdw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:33:52 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Mar 2013 15:33:29 +0100
Subject: Re: [PATCH RFT] pinctrl: abx500: Fix checking if pin use
 AlternateFunction register
Thread-Topic: [PATCH RFT] pinctrl: abx500: Fix checking if pin use
 AlternateFunction register
Thread-Index: Ac4f97q/y+2vi0XRQLufKuBsfApiDg==
Message-ID: <51408E39.80406@st.com>
References: <1362466733.9427.2.camel@phoenix>
 <CACRpkda-BvUQKPPC9rrQiG=p0OUtaqrtYp7uveBFopgqu_WdhQ@mail.gmail.com>
In-Reply-To: <CACRpkda-BvUQKPPC9rrQiG=p0OUtaqrtYp7uveBFopgqu_WdhQ@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 02:59 PM, Linus Walleij wrote:

> On Tue, Mar 5, 2013 at 7:58 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 
>> It's pointless to check "af.alt_bit1 == UNUSED" twice.
>> This looks like a copy-paste bug, I think what we want is to check if *both*
>> af.alt_bit1 and af.alt_bit2 are UNUSED.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Tentatively applied to fixes, waiting for Patrice to confirm...
> 
> Thanks!
> Linus Walleij


Acked-by: Patrice Chotard <patrice.chotard@st.com>

Patrice