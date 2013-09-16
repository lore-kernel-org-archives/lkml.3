Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3IPNiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:38:12 -0400
Received: from outrelay01.libero.it ([212.52.84.101]:40413 "EHLO
	outrelay01.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3IPNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:38:10 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0203.523709BF.0023,ss=1,re=0.000,fgs=0
X-libjamoibt: 1587
Message-ID: <571525005.2373231379338686866.JavaMail.actor@webmail22>
Date: Mon, 16 Sep 2013 15:38:06 +0200 (CEST)
From: Fabio Pedretti <fabio.ped@libero.it>
Reply-To: Fabio Pedretti <fabio.ped@libero.it>
To: stable@vger.kernel.org
Subject: zram commit to backport in 3.2 serie also
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SenderIP: 192.167.16.4
X-libjamv: IUXhxo0BATw=
X-libjamsun: 4R/zWh8kgjzMasaSkJGfUb+zGmQredZf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this patch should be applied in 3.2 as well:
https://lkml.org/lkml/2013/8/13/270

It will fix a regression introduced in the 3.2.49 (same commit in 3.10.6 and 
fix applied in 3.10.7).

Thanks
