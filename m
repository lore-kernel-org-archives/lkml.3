Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaKUV5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:57:43 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:50443 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKUV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:57:39 -0500
Message-ID: <1416607049.27880.20.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 1/1] target: Deletion of unnecessary checks before the
 function call "module_put"
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Fri, 21 Nov 2014 13:57:29 -0800
In-Reply-To: <546F0642.4060007@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	 <530A086E.8010901@users.sourceforge.net>
	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	 <530A72AA.3000601@users.sourceforge.net>
	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	 <530B5FB6.6010207@users.sourceforge.net>
	 <alpine.DEB.2.10.1402241710370.2074@hadrien>
	 <530C5E18.1020800@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251014170.2080@hadrien>
	 <530CD2C4.4050903@users.sourceforge.net>
	 <alpine.DEB.2.10.1402251840450.7035@hadrien>
	 <530CF8FF.8080600@users.sourceforge.net>
	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	 <530DD06F.4090703@users.sourceforge.net>
	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	 <5317A59D.4@users.sourceforge.net> <546F0642.4060007@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 10:30 +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 21 Nov 2014 10:25:45 +0100
> 
> The module_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/target/iscsi/iscsi_target_transport.c | 3 +--
>  drivers/target/target_core_hba.c              | 6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Markus!

--nab

