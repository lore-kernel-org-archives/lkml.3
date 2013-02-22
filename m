Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3BVPlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:41:52 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:32820 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab3BVPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:41:50 -0500
Date: Fri, 22 Feb 2013 10:41:49 -0500 (EST)
From: Rado Vrbovsky <rvrbovsk@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff <jgarzik@redhat.com>
Message-ID: <1914029230.7688830.1361547709132.JavaMail.root@redhat.com>
In-Reply-To: <5127841B.2060207@cogentembedded.com>
Subject: Re: [PATCH] ata_piix: Add MODULE_PARM_DESC to prefer_ms_hyperv
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.1.244]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello.

Hi Sergei,
 
> On 21-02-2013 23:01, Rado Vrbovsky wrote:
> 
> > From: Andrew Brownfield <abrownfi@redhat.com>
> 
> > In reference to the commit cd006086fa5d91414d8ff9ff2b78fbb593878e3c
> > "ata_piix: defer disks to the Hyper-V drivers by default",
> > this trivial patch adds a description to prefer_ms_hyperv.
> 
> > [rvrbovsk@redhat.com: MODULE_PARM_DESC() string formatting
> > modified]
> 
> > Signed-off-by: Andrew Brownfield <abrownfi@redhat.com>
> 
>     Note that you can't jus mechanically add Andrew's signoff to the
>     patch,
> you have to ask him to sign it off... I hope you did.

It was in the original patch and I erased by mistake.

> > Signed-off-by: Radomir Vrbovsky <rvrbovsk@redhat.com>
> 
> MBR, Sergei
> 

Brg,

Rado
