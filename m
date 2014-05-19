Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbaESU4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:56:25 -0400
Received: from mout.gmx.net ([212.227.15.18]:64167 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaESU4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:56:22 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: jdmason@kudzu.us
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, joe@perches.com
Subject: [PATCH v3] vxge: Use time_before()
Date: Mon, 19 May 2014 22:56:00 +0200
Message-Id: <1400532961-7842-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400520928.30820.23.camel@joe-AO725>
References: <1400520928.30820.23.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:p/wRyGRNpht8Mv7buKnmiv3xSNANmYuPPsBRrHj3cZ5uYRrV39I
 vsiLj7wqkhhlg6uEOUvuMIs6kFJ1PwvHLTlXckiLUVpu8e4+87RYjFpgbrz3azFbcGpM4Or
 3rB39mjQ92Q2FZ4VKlhp2OSKzWzHCARMMmA9p9Cn68ph3fwz4Vw5ke/LrHZt3Glsd3SPzcr
 RIjSB8KvJSm/msT0Pq5vQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your hints. I tried to incorporate your points into this new version.

