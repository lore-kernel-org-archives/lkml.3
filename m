Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaFCWof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:44:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44744 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaFCWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:44:33 -0400
From: Benson Leung <bleung@chromium.org>
To: gene.chen@intel.com, moch@chromium.org, mika.westerberg@linux.intel.com,
        kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH 0/3] platform/chrome: chromeos_laptop - Add Haswell Chromebooks
Date: Tue,  3 Jun 2014 15:44:21 -0700
Message-Id: <1401835464-15267-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series should be applied after Mika Westerberg's patch here:
https://patchwork.kernel.org/patch/4288591/

It will add support for the cypress touchpads on the HP Chromebook 14,
Dell Chromebook 11, and Toshiba CB35.

[PATCH 1/3] platform/chrome: chromeos_laptop - Add HP Chromebook 14
[PATCH 2/3] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 Touch
[PATCH 3/3] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
