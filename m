Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3DAD07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:26:59 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:62009 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3DAD06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:26:58 -0400
Date: Sun, 31 Mar 2013 20:22:59 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 0/3] Sync Android pstore updates
Message-ID: <20130401032256.GA13801@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are a few updates from the Android dev tree. Thanks to Arve Hjønnevåg
for the code, and John Stultz for actually preparing commits for
submission.

Unless there are objections, I'll push these updates to linux-pstore.git.

Thanks!

Anton
