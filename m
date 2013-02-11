Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3BKAU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:20:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64300 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BKAU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:20:27 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH 0/1] Platform: x86: chromeos_laptop - Add HP Pavilion 14
Date: Sun, 10 Feb 2013 16:20:16 -0800
Message-Id: <1360542017-1163-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359758086-2320-1-git-send-email-bleung@chromium.org>
References: <1359758086-2320-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will add an entry for one more Chromebook that was released
last week: HP's Pavilion 14 Chromebook. 

This will instatiate that system's Cypress APA trackpad, very similar
to the one in the Samsung 550 and Acer C7.

This should be merged after the previous patch series of 4:
Platform: x86: chromeos_laptop - Add more x86 Chromebooks

Thanks,
Benson

