Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3FEFnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:43:10 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51112 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3FEFnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:43:07 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] firmware loader: cleanup and introduce search paths option
Date: Wed,  5 Jun 2013 13:42:46 +0800
Message-Id: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 1st patch cancels exporting of cache_firmware and uncache_firmware.

The 2nd one simplifies holding module for request_firmware().

The 3rd one introduces one kernel option to allow distributions or users
to set their specific firmware search paths.

 drivers/base/Kconfig          |   12 ++++++
 drivers/base/firmware_class.c |   95 +++++++++++++++++++++++++++++++++--------
 include/linux/firmware.h      |   11 -----
 3 files changed, 89 insertions(+), 29 deletions(-)



Thanks,
--
Ming Lei

