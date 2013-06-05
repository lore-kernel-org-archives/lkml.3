Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3FELBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:01:11 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34969 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013Ab3FELBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:01:08 -0400
From: Matthias Schid <aircrach115@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, sjakub@gmail.com, jonbrett.dev@gmail.com,
        cruz@massive-dynamics.biz, joe@perches.com, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, steffhip@googlemail.com,
        simon.puels@gmail.com, Matthias Schid <aircrach115@gmail.com>
Subject: [PATCH 0/2] staging/asus_oled fixed style issues
Date: Wed,  5 Jun 2013 12:50:43 +0200
Message-Id: <1370429445-17185-1-git-send-email-aircrach115@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed alignment issue and a linebreak issue reported 
by checkpatch.pl in asus_oled

Matthias Schid (2):
  staging/asus_oled fixed alignment in defines
  staging/asus_oled fixed linebreak style issue

 drivers/staging/asus_oled/asus_oled.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
1.7.10.4

