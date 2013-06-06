Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab3FFAYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:24:20 -0400
Received: from vps1.hno.se ([31.192.227.87]:39852 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab3FFAYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:24:19 -0400
Message-ID: <1370478224.20454.69.camel@localhost>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Date: Thu, 06 Jun 2013 02:23:44 +0200
In-Reply-To: <CAPweEDwrpoYCFuWJvF99Yua_TBoONeEH8UkTZvC7dTev6FAYfw@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	 <CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
	 <1370468873.18839.22.camel@localhost>
	 <CAPweEDwrpoYCFuWJvF99Yua_TBoONeEH8UkTZvC7dTev6FAYfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ons 2013-06-05 klockan 23:20 +0100 skrev luke.leighton:

>  ok: great.  so we have something that i can potentially propose to
> them.   now: what reason can i give that they should accept this?
> what's the biggest incentive for them, here, to make these changes?
> what would they gain?

Mainly a common infrastructure so they don't need to hack every driver
to work with their scheme.

But there is no way to escape from the fact that first round will be far
more complicated than just adding their own stuff as-is likely is. Many
of the upstreamed drivers are rewritten and far from their drivers.

And further complicated by their supported designs often using devices
(wifi modules, touch panels, nand chips, etc) where 3 year old barely
maintained vendor code actually works better than what is currently in
the upstream kernel. 

So no, I can not say that there is an easy road ahead,

Regards
Henri

