Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaH0J1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:27:22 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48881 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135AbaH0J1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:27:19 -0400
Message-ID: <53FDA463.8040704@ahsoftware.de>
Date: Wed, 27 Aug 2014 11:26:59 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Loeliger <jdl@jdl.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826102503.GC31124@ulmo> <53FC6513.5040800@ahsoftware.de> <20140826110827.GA31350@ulmo> <53FC6E4A.6030407@ahsoftware.de> <20140826114718.GB641@ulmo> <53FC76E8.5050009@ahsoftware.de> <E1XMHGc-0008TS-CQ@jdl.com> <53FD85C7.4080900@ahsoftware.de>
In-Reply-To: <53FD85C7.4080900@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.08.2014 09:16, schrieb Alexander Holler:

> Why should I? I've posted patches along with a lot of comments and
> explanations, and e.g. you are just talking that it should be made like
> my patches already did. And others do talk too like my patches and the
> accompanying comments from me which explain most stuff never have
> existed and just repeat what the patches already do without refering to
> them.

Just to repeat myself:

These patches which started this thread are not just some ideas without 
any sense for the amount of work necessary to implement them (as seen so 
often).

These patches are real working code everyone can apply to the mentioned 
kernel version and see what happens with his board. They are even 
checkpatched to avoid bean counting discussion.

(Don't forget to use patch 10/9 too)

Regards,

Alexander Holler
