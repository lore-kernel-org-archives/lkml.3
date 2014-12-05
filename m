Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaLEMud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:50:33 -0500
Received: from mout.web.de ([212.227.15.4]:65331 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaLEMub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:50:31 -0500
Message-ID: <5481AA10.20707@users.sourceforge.net>
Date: Fri, 05 Dec 2014 13:50:24 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 6/6] net-PPP: Delete another unnecessary assignment
 in mppe_alloc()
References: <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com> <547C82A6.2030808@users.sourceforge.net> <547CA157.1080401@cogentembedded.com> <5480DA32.8000201@users.sourceforge.net> <5480DE25.2020802@users.sourceforge.net> <20141205122315.GC4912@mwanda>
In-Reply-To: <20141205122315.GC4912@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:1IL6sLBFxpla3EKYJ3K5muTuJH+DB/pzqiS0aNvZd4YxEK2iKg8
 Q0GDZErMuC0uwWepuqCvXuIKSIPTVmc2oEjSMlJWLaTFIBn1/sNcOJSFoZzRQu8ytX6uYzJ
 1qbhq+8Vue6iR5EOStyoy079EWaYkU+TmnuAI5by9E23Zdi65j0DLNTNljT+XAdzB3FGFLk
 tkt2Ov71UBlMbDpj9vXoQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The data structure element "sha1" was assigned a null pointer by the
>> mppe_alloc() after a function call "crypto_alloc_hash" failed.
> 
> This patch is also buggy.

Do you really want to keep a variable reset after a detected failure?

Regards,
Markus

