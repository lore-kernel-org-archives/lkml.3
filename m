Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaKPMHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:07:48 -0500
Received: from mout.web.de ([212.227.17.12]:59006 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaKPMHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:07:47 -0500
Message-ID: <5468938B.502@users.sourceforge.net>
Date: Sun, 16 Nov 2014 13:07:39 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kernel-audit: Deletion of an unnecessary check before
 the function call "audit_log_end" (or improve error handling?)
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54687F1A.1010809@users.sourceforge.net> <20141116112457.GB4905@mwanda>
In-Reply-To: <20141116112457.GB4905@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:bFhCoWUEYUs5LRmiDtwQnkXuFl5etkrTtcVlnIkwgooKVBG1gSm
 K30QwRL/+TXRQJYbu0m/xaGpV6x/EyokxoK1tpMRmNXwAqxjoFsg64DPOf8DkaQ9Vbb5h2R
 vrnNIJ8vnMTuqJje4JUbgowb6gxIhJj5yi3pLFTpnCjytsRfR1rjSkko1uNtX8GnVu1LkBr
 OHh7lC9d17yukCZt+rIfg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The original code is very clear, the new code works exactly the same but
> it's not clear if the author forgot about handling errors from
> audit_log_start().

We have got different expectations on source code clarity here.


> So now someone will come along later and add:
> 	if (!ab)
> 		return;
> 
> We get a lot of mindless "add error handling" patches like that.

This is an interesting background information.

Do you eventually prefer to improve the affected error detection
and corresponding exception handling?
Will a condition check become absolutely necessary there?

Regards,
Markus
