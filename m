Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3KRLZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:25:01 -0500
Received: from mout.gmx.net ([212.227.17.20]:56461 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3KRLY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:24:56 -0500
MIME-Version: 1.0
Message-ID: <trinity-96b74089-565e-468c-a456-ac73dc4b097e-1384773895118@3capp-gmx-bs60>
From: "Helge Deller" <deller@gmx.de>
To: "Simon Baatz" <gmbnomis@gmail.com>
Cc: "Benjamin LaHaise" <bcrl@kvack.org>,
        "James Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: Aw: Re: [PATCH] aio: fix D-cache aliasing issues
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 Nov 2013 12:24:55 +0100 (CET)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131118105443.GA19633@schnuecks.de>
References: <20131115220529.GA3160@ls3530.box>
 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
 <20131116200717.GA18939@schnuecks.de> <20131116200959.GA14098@kvack.org>
 <528933BC.50806@gmx.de>, <20131118105443.GA19633@schnuecks.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:t57iw3FeB7Pf//X3LT9gCoz82sSIF3MLLoMqYW8Xybq
 DqT6NEfGPWGadJhzM51VixfZa1Hs48PlF8QSK5QwvCgNug2uzF
 ODgRmRibE1xHdkRINRRx3LYXdH9LZxBF3EAqWy2ZjFmpkuIn6Z
 AeZOwlraSh/FmYSsz5tyZqAo99mKCbUJ2Cd1EBtZRbgNvw0BDl
 PKSfeK6nBgxKA+jduXzv0M14cXkpGiJcKa8n1FD8w2I5z+h8et
 q+eV8ud8tcHh0hpnnIcx64UVSqYpIgFgO2ChFICmfw4B4wnOU+ tWAfgU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Helge,
> Could you provide me with the test case(s) you are running to
> reproduce the problem?  I could test this on aliasing D-cache on ARM
> as well. Since kmap/kunmap do not flush in general on ARM, we
> might need the explicit flushes here.

Just google for aio-stress.c (e.g. https://github.com/repoforge/rpms/blob/master/specs/aio-stress/aio-stress.c).
And the aio01 / aio02 testcases from the Linux Test Project (https://github.com/linux-test-project/ltp).

Helge
