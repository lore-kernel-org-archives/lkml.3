Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaGSTg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:36:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59318 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaGSTg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:36:26 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, josh@joshtriplett.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: staging: lustre/lustre/lov: Cleanup style issues in lov_request.c
Date: Sat, 19 Jul 2014 21:34:55 +0200
Message-Id: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series fixes two coding style issues and removes an unneeded
'if' statement in lov_request.c.

Thanks,
riccardo

