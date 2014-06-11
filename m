Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaFKQoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:44:03 -0400
Received: from smtp-o-3.desy.de ([131.169.56.156]:44034 "EHLO smtp-o-3.desy.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbaFKQoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:44:01 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 12:44:01 EDT
Date: Wed, 11 Jun 2014 18:33:41 +0200 (CEST)
From: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>
To: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Andy Adamson <william.adamson@netapp.com>,
        Steve Dickson <steved@redhat.com>
Message-ID: <955256583.2570604.1402504421889.JavaMail.zimbra@desy.de>
In-Reply-To: <1749916670.2570521.1402503768494.JavaMail.zimbra@desy.de>
Subject: pNFS client behavior confirmation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF29 (Linux)/8.0.7_GA_6021)
Thread-Topic: pNFS client behavior confirmation
Thread-Index: teDiqDHp3gtAukhkSVWozYuVDTom3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dear pnfs developers,

I would like to confirm client behavior which was hurting us for years.

If for some reason the client is unable to connect to a DS, then this DS got blacklisted
and the only way to whitelist it again was client reboot. With RHEL7 (and I believe with
upstream kernel), after 2 mins client 'forgets' about bad DS and uses it again. This
behavior is tested and confirmed during June bakeathon.

Missing bits:

  i) it takes client 6 min to fall back to MDS, e.g time between LAYOUTGET and first WRITE to MDS 
  ii) there are no log entries why client have decided to use MDS

Thanks,
   Tigran.
