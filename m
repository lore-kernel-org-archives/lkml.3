Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3CTPeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:34:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35875 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3CTPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:34:08 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sysfs: fix use after free in sysfs_readdir()
Date: Wed, 20 Mar 2013 23:25:23 +0800
Message-Id: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches fix two bugs inside sysfs_readdir(), and both
the two bugs may cause use after free problem, which is reported
by Dave on trinity fuzz test on syscall.


Thanks,
--
Ming Lei

