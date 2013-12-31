Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3LaRAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:00:51 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57116 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3LaRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:00:49 -0500
Message-ID: <1388509244.3924.1.camel@phoenix>
Subject: regulator: question about commit d886a041646 pfuze100-regulator:
 Fix MODULE_ALIAS()
From: Axel Lin <axel.lin@ingics.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Jan 2014 01:00:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I just found this commit after pull regulator updates.
So why to use 'platform' prefix in MODULE_ALIAS for i2c driver?
Does it really work? 

Regards,
Axel

