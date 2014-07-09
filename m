Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaGIMH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:07:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64945 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaGIMH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:07:57 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] line wrapping of changelog
Date: Wed,  9 Jul 2014 17:49:38 +0530
Message-Id: <1404908382-7043-1-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20140708100142.GR25934@mwanda>
References: <20140708100142.GR25934@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

line wrap the changelog as per Dan

sanjeev sharma (4):
  staging: rtl8192u: Remove useless return statements.
  staging: rtl8192u: Removed unnecessary whitespace & tab warning.
  staging: rtl8192u: Fixed switch and case indentation error.
  staging: rtl8192u: Fixed too long lines

 drivers/staging/rtl8192u/r819xU_phy.c | 58 +++++++++++++++--------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

-- 
1.7.11.7

