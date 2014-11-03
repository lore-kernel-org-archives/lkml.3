Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKCN1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:27:17 -0500
Received: from mout.web.de ([212.227.17.11]:61503 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaKCN1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:27:14 -0500
Message-ID: <545782AA.5080408@users.sourceforge.net>
Date: Mon, 03 Nov 2014 14:27:06 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ilya Dryomov <ilya.dryomov@inktank.com>
CC: Sage Weil <sage@inktank.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>, "Yan, Zheng" <zyan@redhat.com>
Subject: Re: ceph: Deletion of unnecessary checks before two function calls
References: <5307CAA2.8060406@users.sourceforge.net>	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>	<530A086E.8010901@users.sourceforge.net>	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	<530A72AA.3000601@users.sourceforge.net>	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	<530B5FB6.6010207@users.sourceforge.net>	<alpine.DEB.2.10.1402241710370.2074@hadrien>	<530C5E18.1020800@users.sourceforge.net>	<alpine.DEB.2.10.1402251014170.2080@hadrien>	<530CD2C4.4050903@users.sourceforge.net>	<alpine.DEB.2.10.1402251840450.7035@hadrien>	<530CF8FF.8080600@users.sourceforge.net>	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	<530DD06F.4090703@users.sourceforge.net>	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	<5317A59D.4@users.sourceforge.net>	<54563DCB.2010103@users.sourceforge.net> <CALFYKtAJG5W9-BAHrqEcC-FfqdJERCqkBADo4yTUyjzb+wCHnQ@mail.gmail.com>
In-Reply-To: <CALFYKtAJG5W9-BAHrqEcC-FfqdJERCqkBADo4yTUyjzb+wCHnQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ZQ+eMP1vPBlDRHc47d1nQL6BnY1Qm08UgUcioKDm3Aw9Ab19tPh
 SRN9E6obZNM1ZhGFbwXgpQNXX7QvZDmo4HDndGz2Vhv/Y+X3CnyiDUoKmHmdRXpWLnq+Y4c
 cPcA+n5nb2I/1FbIkvVonGqbp2cATZcUsjaWlnn+VoDO7qvgIqzTWa74tIwma+X5u0MDCR1
 /ryWjm1/rtsqKEWmwManA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dput() also checks for NULL argument, but the check is wrapped into
> unlikely(), which is why I presume it wasn't picked up.  It would be
> great if you could improve your coccinelle script to handle
> {un,}likely() as well.

Thanks for your suggestion.

Should I consider any more fine-tuning for the affected script
"list_input_parameter_validation1.cocci" in the near future?
https://lkml.org/lkml/2014/3/5/362
http://article.gmane.org/gmane.comp.version-control.coccinelle/3514


>> @@ -590,15 +589,13 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm
>> *realm)
> 
> The patch was corrupted, that should have been a single line.  I fixed
> it up but you may want to look into your email client settings.

Thanks for your feedback.

Does this example show a conflict between long comments after patch ranges and
line length limitation for email eventually?

Regards,
Markus
