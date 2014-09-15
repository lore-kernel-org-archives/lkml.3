Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbaIOVG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:06:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaIOT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Binderman <dcb314@hotmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 036/158] powerpc/mm/numa: Fix break placement
Date: Mon, 15 Sep 2014 12:24:35 -0700
Message-Id: <20140915192543.969361051@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

commit b00fc6ec1f24f9d7af9b8988b6a198186eb3408c upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81631
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -611,8 +611,8 @@ static int cpu_numa_callback(struct noti
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
-		break;
 		ret = NOTIFY_OK;
+		break;
 #endif
 	}
 	return ret;


