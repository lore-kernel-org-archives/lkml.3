Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3HUUGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:06:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3HUUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:06:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] powerpc/spufs: convert userns uid/gid mount options to kuid/kgid
Date: Wed, 21 Aug 2013 22:05:27 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ben Myers <bpm@sgi.com>, Jeremy Kerr <jk@ozlabs.org>,
        cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au> <20130821155654.GI5262@sgi.com> <20130821143351.5840d556@oracle.com>
In-Reply-To: <20130821143351.5840d556@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308212205.27789.arnd@arndb.de>
X-Provags-ID: V02:K0:Xb4fz1buZRkitCsIR/argFgh+PwgPTk2dsmXyNA7tQY
 LtxiU8AtgKck9YV8woov/qIko0T/cBZnw9pr9i5Pi8lClvoMrV
 71xT0utAc/7gdRQ3ECnAdhzUv1unG+4X2dGnA30N90U4ruOK6Q
 uhYBjWR2D2AXPzShTb20ronQWPeH1NZ4Pc5FJYweq+ciLAnW9Y
 4+Qzp7wWjfo4r4b2xiCjDG8Nsq0QG/MX8e1jexAyuxg0V5amy9
 RzOaiqHov1Pq59iEH+sSG+1vlxg5bjMFRxSHik58FCaMV96pJp
 7x6qjOYp76Y684zwSfN6gBUdAGaVp+OCtNUigfGEtaOkmuE2fZ
 +VY2clQLwov6nyvzPXNg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 August 2013, Dwight Engen wrote:
> 
> Acked-by: Jeremy Kerr <jk@ozlabs.org>
> Tested-by: Jeremy Kerr <jk@ozlabs.org>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
