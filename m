Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3FXMXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:23:48 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:46862 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab3FXMXr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:23:47 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier CLERGEAUD <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Date: Mon, 24 Jun 2013 14:23:41 +0200
Subject: Re: [PATCH v2 4/4] pinctrl: abx500: rework error path
Thread-Topic: [PATCH v2 4/4] pinctrl: abx500: rework error path
Thread-Index: Ac5w1aoHVhgPoJJOTUu76bTAmWMxtw==
Message-ID: <51C83A4D.9030903@st.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
 <1371737145-27662-5-git-send-email-patrice.chotard.st@gmail.com>
 <CACRpkdZm-A-CVU+Lf=74HR71gH2fwTsigv7gJRGTS2seL=Vs=A@mail.gmail.com>
In-Reply-To: <CACRpkdZm-A-CVU+Lf=74HR71gH2fwTsigv7gJRGTS2seL=Vs=A@mail.gmail.com>
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

On 06/24/2013 01:37 PM, Linus Walleij wrote:

> On Thu, Jun 20, 2013 at 4:05 PM,  <patrice.chotard.st@gmail.com> wrote:
> 
>> From: Patrice Chotard <patrice.chotard@st.com>
>>
>> At several places, return value was not tested
>> and error output was missing.
>>
>> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
> 
> This looks fine, but does not apply since I didn't accept patch 1/4.


I am surprised that patch 4/4 doesn't apply, because in my side i am
able to apply it on your devel branch even without patch 1/4

Anyway, i'll submit 1/4 and 4/4.

Thanks

Patrice

>

> Please resend 1/4 and this 4/4 after fixing up 1/4.
> 
> (You can rebase onto devel if you want to be 100% sure it applies.)
> 
> Yours,
> Linus Walleij

