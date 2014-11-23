Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaKWTD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:03:59 -0500
Received: from mout.web.de ([212.227.17.11]:58857 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbaKWTD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:03:57 -0500
Message-ID: <54722F88.8050805@users.sourceforge.net>
Date: Sun, 23 Nov 2014 20:03:36 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Joe Perches <joe@perches.com>, Andreas Noever <andreas.noever@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
References: <5307CAA2.8060406@users.sourceforge.net>  <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>  <530B5FB6.6010207@users.sourceforge.net>  <alpine.DEB.2.10.1402241710370.2074@hadrien>  <530C5E18.1020800@users.sourceforge.net>  <alpine.DEB.2.10.1402251014170.2080@hadrien>  <530CD2C4.4050903@users.sourceforge.net>  <alpine.DEB.2.10.1402251840450.7035@hadrien>  <530CF8FF.8080600@users.sourceforge.net>  <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>  <530DD06F.4090703@users.sourceforge.net>  <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>  <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>  <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>  <546F2E50.5040804@users.sourceforge.net>  <1416593688.6651.39.camel@perches.com>  <5471EBAC.40903@users.sourceforge.net> <1416756022.6651.45.camel@perches.com> <54720061.7010401@users.sourceforge.net> <alpine.DEB.2.02.1411231650580.2037@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1411231650580.2037@localhost6.localdomain6>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:L8XVr5Dhr3kiexaIE2sS/iAmbgKNfwbOw7fHzb+oAYJblFZQmQL
 gZj91+dZ2lgmX/dNlZu8AYkKbwTD5Qb8YyIrNahxKn3swwP1NfxPVJqOxV0GJ9ZcrejN2OY
 /b01UE3mTOlbV2YSe2WDY8ziILiVCVWpff3eNvo1NfCOhKJEmCriXB7IFfAJctrL6HZgczF
 yS4emFphMdcm8VBn219jQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not just make the static source code analysis aware of the problem?

This is also possible, of course.


> You can treat static functions differently that non-static ones.

I have added this detail to my ideas around the next fine-tuning
for the published semantic patch approach.


> There is no need to change the code.

Can name space prefixes help to make source code a bit safer eventually?

Regards,
Markus
