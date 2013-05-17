Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3EQVhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:37:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3EQVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 007/102] ASoC: wm8994: missing break in wm8994_aif3_hw_params()
Date: Fri, 17 May 2013 14:35:22 -0700
Message-Id: <20130517213245.113074333@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4495e46fe18f198366961bb2b324a694ef8a9b44 upstream.

The missing break here means that we always return early and the
function is a no-op.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2841,6 +2841,7 @@ static int wm8994_aif3_hw_params(struct
 		default:
 			return 0;
 		}
+		break;
 	default:
 		return 0;
 	}


