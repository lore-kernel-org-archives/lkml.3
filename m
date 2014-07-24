Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934996AbaGXXHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:07:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45188 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759702AbaGXXHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:06 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] staging: vt6655: Sparse and checkpatch fixes
Date: Fri, 25 Jul 2014 01:06:14 +0200
Message-Id: <1406243188-13413-1-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes a lot of minor checkpatch and sparse warnings.

