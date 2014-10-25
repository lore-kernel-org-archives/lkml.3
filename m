Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaJYBDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 21:03:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33668 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaJYBDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 21:03:12 -0400
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: lustre: Minor lnet module cleanup
Date: Sat, 25 Oct 2014 03:00:32 +0200
Message-Id: <1414198834-19470-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix some sparse warnings and apply __init and __exit 
markers to module's init and exit functions.

Mariusz Gorski (2):
  staging: lustre: Reduce function visibility
  staging: lustre: Use __init and __exit markers for lifecycle functions

 drivers/staging/lustre/lnet/lnet/module.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.1.2

