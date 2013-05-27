Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3E0KaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:30:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42754 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3E0KaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:30:16 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] firmware loader: avoid blocking suspend by !uevent requests
Date: Mon, 27 May 2013 18:30:02 +0800
Message-Id: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, Takashi reported that requests with FW_ACTION_NOHOTPLUG may block
shutdown and fixed that by killing pending requests before shutdown. But
these requests still may block suspend, so the 2 patches is introduced to
fix the problem during suspend.

The 2nd patch depends on Takashi Iwai's patch of "firmware: Avoid deadlock of
usermodehelper lock at shutdown".

Thanks,
--
Ming Lei

