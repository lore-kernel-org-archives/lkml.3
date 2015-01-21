Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbbAULxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:53:37 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58133 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbAULx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:53:29 -0500
Date: Wed, 21 Jan 2015 13:53:03 -0900
From: Ahmad Hassan <ahmad.hassan612@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, vinc94@gmail.com, roberta.dobrescu@gmail.com,
        sachin.kamat@samsung.com, ebru.akagunduz@gmail.com,
        damm+renesas@opensource.se, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Replacing ERR by dev_err
Message-ID: <cover.1421880617.git.ahmad.hassan612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set removes the macro ERR from emxx_udc.h and accordingly
emxx_udc.c occurrences of ERR changes to dev_err

Ahmad Hassan (2):
  staging: emxx_udc: Replace ERR by dev_err
  staging: emxx_udc: remove macro ERR

 drivers/staging/emxx_udc/emxx_udc.c | 80 ++++++++++++++++++-------------------
 drivers/staging/emxx_udc/emxx_udc.h |  1 -
 2 files changed, 40 insertions(+), 41 deletions(-)

-- 
2.2.1

