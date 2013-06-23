Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3FWWK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 18:10:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43193 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab3FWWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 18:10:56 -0400
Message-ID: <51C7725C.5090801@zytor.com>
Date: Sun, 23 Jun 2013 15:10:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: MTRR use in drivers
References: <51C3DDFA.7050204@zytor.com> <51C69732.1010906@gmail.com> <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com> <20130623192936.GA28655@khazad-dum.debian.net> <51C75465.9060007@zytor.com> <20130623215649.GA1288@khazad-dum.debian.net>
In-Reply-To: <20130623215649.GA1288@khazad-dum.debian.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 02:56 PM, Henrique de Moraes Holschuh wrote:
> 
> And as far as I could find from Intel's not-that-complete public
> "specification updates", we are applying the errata workaround to a few more
> processors than strictly required, but since I have no idea how to write a
> test case, I can't whitelist the 3rd-gen Pentium M on my T43, nor can I get
> ThinkPad owners to test it for us on 1st and 2nd-gen Pentium M and report
> back.
> 

Which specific erratum are you referring to, here?  The "WC becomes UC"
erratum?  I don't think there is a sane testcase for it since it needs a
very complicated setup to trigger.

	-hpa

