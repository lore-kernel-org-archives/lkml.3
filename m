Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965273AbaFQVYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:24:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63591 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaFQVYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:24:32 -0400
From: Benson Leung <bleung@chromium.org>
To: gene.chen@intel.com, moch@chromium.org, mika.westerberg@linux.intel.com,
        lkml14@scotdoyle.com, kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCHv2 0/4] platform/chrome: chromeos_laptop - Add Haswell Chromebooks
Date: Tue, 17 Jun 2014 14:01:59 -0700
Message-Id: <1403038923-19444-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1401835464-15267-1-git-send-email-bleung@chromium.org>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series  will add support for the cypress touchpads on the
HP Chromebook 14, Dell Chromebook 11, and Toshiba CB35.

Based on the work here by Mika Westerberg, which this series incorporates :
https://patchwork.kernel.org/patch/4288591/

[PATCHv2 1/4] platform/chrome: chromeos_laptop - Add support for Acer C720
[PATCHv2 2/4] platform/chrome: chromeos_laptop - Add HP Chromebook 14
[PATCHv2 3/4] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 Touch
[PATCHv2 4/4] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
