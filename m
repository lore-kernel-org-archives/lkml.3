Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab3FFMCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:02:07 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61708 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab3FFMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:02:05 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/4] firmware loader: cleanup and introduce search paths option  
Date: Thu,  6 Jun 2013 20:01:46 +0800
Message-Id: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 1st patch cancels exporting of cache_firmware and uncache_firmware.

The 2nd one simplifies holding module for request_firmware().

The 3rd one introduces one kernel option to allow distributions or users
to set their specific firmware search paths.

The 4th one don't allow to request firmware via relative path.

V1:
	- 3/4: make code more clean, take the approach suggested by Takashi
	- 4/4: introduce 4/4	


 drivers/base/Kconfig          |   14 +++++++
 drivers/base/firmware_class.c |   91 ++++++++++++++++++++++++++++++++---------
 include/linux/firmware.h      |   11 -----
 3 files changed, 85 insertions(+), 31 deletions(-)

Thanks,
--
Ming Lei

