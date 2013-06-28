Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3F1Ngb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:36:31 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62120 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3F1Nga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:36:30 -0400
Message-ID: <1372426585.28529.5.camel@phoenix>
Subject: regulator: Is there any reason the 88PM800 regulator driver can not
 be built as module?
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 21:36:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I ask this because MFD_88PM800 can be built as module.
So any reason REGULATOR_88PM800 must be bool?

Regards,
Axel

