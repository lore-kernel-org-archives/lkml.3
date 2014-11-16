Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaKPLsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 06:48:52 -0500
Received: from mout.web.de ([212.227.15.4]:54382 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbaKPLsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 06:48:51 -0500
Message-ID: <54688F15.9070703@users.sourceforge.net>
Date: Sun, 16 Nov 2014 12:48:37 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kernel-audit: Deletion of an unnecessary check before
 the function call "audit_log_end"
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54687F1A.1010809@users.sourceforge.net> <20141116111023.GA4905@mwanda> <20141116111446.GA4956@mwanda>
In-Reply-To: <20141116111446.GA4956@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:OrrsUlRAqO+QXoId7/ZPaL8nw23T5aeGBJHdzZyaC5YeHWQimP9
 t058VMLFyD3bcRo6dL/Vy4MB56ieiMzIa2WUXhaz8EFt2dXXmNXyaEgLTjmsCH9oXaPp00E
 jQzyDeQKdLgyxyKuNg8HwYRHoNsIgKlGXVxpXSdwM7xdn+ff5CBvNx76e3EKvprb9ArJ2Qn
 F/sWDj18coIedbzbPjlGw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> An example of a bug introduced is here:
> 
> https://lkml.org/lkml/2014/11/3/505

It seems that we try to clarify a different interpretation of "bugs", don't we?

It is an usual software development challenge to decide on the best source code places
where to put input parameter validation (and when it can be omitted), isn't it?

Regards,
Markus
