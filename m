Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaGTE7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:59:45 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52571 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaGTE7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:59:43 -0400
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 00:59:42 -0400
Message-ID: <CAPDOMVjnK=OF8mQrXbbgGUtCRJO8oG4+PQOETEcskNk=95GLrg@mail.gmail.com>
Subject: solos-pci.c: Fix me
From: Nick Krause <xerofoify@gmail.com>
To: chas@cmf.nrl.navy.mil
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Chas,
There seems to be a fix me in this file in the function, solos_bh.
Is the default statement correct and I remove the fix me or
does it need to be rewritten.
Cheers Nick
