Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab3CYR0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:26:53 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:36550 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab3CYR0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:26:51 -0400
MIME-Version: 1.0
Date: Mon, 25 Mar 2013 18:26:50 +0100
Message-ID: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
Subject: RE: ata: HDIO_DRIVE_* ioctl() Linux 3.9 regression
From: Ronald <ronald645@gmail.com>
To: krzysiek@podlesie.net, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In reply to [1]: I have the same issue. Git bisect took 50+ rebuilds xD

Smartd does not work anymore since 84a9a8cd9 ([libata] Set proper SK
when CK_COND is set.).

I hope I'm not stepping on anyone's toe's by chosing the same title.
I'm not subscribed to this list.

Just wanted to add a 'me2'

[1] http://www.spinics.net/lists/linux-ide/msg45268.html
