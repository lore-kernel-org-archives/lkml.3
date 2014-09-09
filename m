Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaIIToL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:44:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:53402 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaIIToK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:44:10 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Scot Doyle <lkml14@scotdoyle.com>
Subject: Re: [PATCH] tpm: fix interrupt timeouts
Date: Tue, 9 Sep 2014 21:44:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.1; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.11.1408250710470.1443@localhost.localdomain>
In-Reply-To: <alpine.LNX.2.11.1408250710470.1443@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409092144.35387.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:o+xTGMZGeVUYQ2CRlNzeh6Nf7q1Ysa444RqG0qhdH1BZU+OPRRR
 vpu2yPbTSitHpoQO+0QtpWa8s0ZAiUJHHDBFN6lFv+169KjSjfW6/+nRJ+Lf8uHc7n4rPFG
 IBUecc06qx37WMxLevR71Yf3V/ALl7gIRo1liIeDhYQac16RKKtDqnmvmBe35A2CJJ104mb
 /wONWrSmPEmGQ4tjaoaUA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scot,
Am Montag, 25. August 2014, 09:14:03 schrieb Scot Doyle:
> commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e
>     wait: fix false timeouts when using wait_event_timeout()
> 
> changed the semantics of wait_event_interruptible_timeout so that a
> condition check is performed after timeout and 1 is returned if true.

is this one still valid or superseeded by one of the other patches?

Thanks,
Peter

