Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbaLAUgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:36:39 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57807 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaLAUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:36:35 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:643c:8d32:1602:17de]
In-Reply-To: <547A09B1.9090102@users.sourceforge.net>
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
	<5317A59D.4@users.sourceforge.net>
	<547A09B1.9090102@users.sourceforge.net>
Date: Mon, 1 Dec 2014 12:36:33 -0800
Message-ID: <CAOesGMi+=ue34aQcDH0wPBjrvi+3cSJG1=m9fbj+tgds_twkPg@mail.gmail.com>
Subject: Re: [PATCH 1/1] net-PA Semi: Deletion of unnecessary checks before
 the function call "pci_dev_put"
From: Olof Johansson <olof@lixom.net>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 10:00 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 29 Nov 2014 18:55:40 +0100
>
> The pci_dev_put() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call
> is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

For this particular case:

Acked-by: Olof Johansson <olof@lixom.net>

Note that the "this might cause problems with backports" case is
mostly academic in the scope of _this particular driver_. It's still a
very valid discussion and issue though.

So I'll be happy to give the ack on this driver, but the larger
problem needs consideration still.


-Olof
