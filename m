Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3FFVBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:01:20 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49351 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab3FFVBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:01:18 -0400
From: Laura Lawniczak <laura.lawniczak@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 0/1] keucr: remove unused variable warning 
Date: Thu,  6 Jun 2013 22:50:50 +0200
Message-Id: <1370551851-13456-1-git-send-email-laura.lawniczak@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130606201631.GB14773@kroah.com>
References: <20130606201631.GB14773@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this will remove the unused variable warning caused by previous patch series.

regards,
Laura Lawniczak

Laura Lawniczak (1):
  keucr: restored lost line

 drivers/staging/keucr/transport.c |    1 +
 1 file changed, 1 insertion(+)

-- 
1.7.10.4

