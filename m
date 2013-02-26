Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab3B0BHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:07:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3BZX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: [ 066/150] drm/radeon: remove overzealous warning in hdmi handling
Date: Tue, 26 Feb 2013 15:55:23 -0800
Message-Id: <20130226235531.070642062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c944b2abb067130542055666f23409fd5e1afc8e upstream.

hdmi audio works fine.  The warning just confuses users.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=44341

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -544,7 +544,6 @@ void r600_hdmi_disable(struct drm_encode
 
 	/* Called for ATOM_ENCODER_MODE_HDMI only */
 	if (!dig || !dig->afmt) {
-		WARN_ON(1);
 		return;
 	}
 	if (!dig->afmt->enabled)


