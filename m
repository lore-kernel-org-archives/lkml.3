Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbaIQTfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:35:50 -0400
Received: from mout.gmx.net ([212.227.17.22]:63224 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbaIQTfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:35:48 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Eric Biederman <ebiederm@xmission.com>
Cc: kexec@lists.infradead.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: kexec.h:61: userspace cannot reference function or variable defined in the kernel
Date: Wed, 17 Sep 2014 21:35:23 +0200
Message-Id: <1410982523-8227-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:exrA7TeubUSonVo16gazhgjL7GBebyy9wvpDkDzcalKuuED9R+h
 Ixji3yTZz0ZcvGco0hmiCMDzWAGd2gH40uX205KnoAwkGKwGWyPAj/XbPJxLBCcJtMsA4qP
 eYqkon1wUu2aGOsmndWBD2Zz6kh0XH0kPFrkVXvHXGdgCnL4cbGC83A3pTbHS6ZrwUeY8RW
 OMw+6qZ4Fl3lnWC37BUVA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make headers_check
on mips cavium octeon
for v3.17-rc5
results in
kexec.h:61: userspace cannot reference function or variable defined in the
 kernel

Best regards

Heinrich Schuchardt

