Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaCaUzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:55:55 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37368 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaCaUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:55:50 -0400
Message-ID: <5339D654.7040702@gmail.com>
Date: Mon, 31 Mar 2014 22:55:48 +0200
From: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 0/2] staging: comedi: some checkpatch.pl style fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For Eudyptula Task10 I've fixed some checkpatch.pl coding style issues.

Yves Deweerdt (2):
  staging: comedi: comedy_fops.c: fix line over 80 characters warnings
  staging: comedi: drivers.c: Fix missing a blank line after
    declarations warning

 drivers/staging/comedi/comedi_fops.c | 6 ++++--
 drivers/staging/comedi/drivers.c     | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
1.8.3.2

