Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3EPINK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:13:10 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45285 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3EPINH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:13:07 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: nico@fluxnic.net, cjb@laptop.org
Cc: andrew@lunn.ch, thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
        jg1.han@samsung.com, sachin.kamat@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] drivers: mmc: host: use devm_ioremap_resource()
Date: Thu, 16 May 2013 10:22:00 +0200
Message-Id: <1368692521-16991-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This second version fix a typo in commit message reported by Jingoo Han

Regards,
Laurent.
