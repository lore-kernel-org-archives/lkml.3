Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3H3MMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:12:44 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54857 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H3MMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:12:43 -0400
Message-ID: <1377864759.12097.5.camel@phoenix>
Subject: regulator: da9063: Question about irq_uvov
From: Axel Lin <axel.lin@ingics.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 20:12:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulators->irq_uvov is not used, and thus is never requested.
In da9063_regulator_remove(), why current code calls
        free_irq(regulators->irq_uvov, regulators); 

Regards,
Axel

