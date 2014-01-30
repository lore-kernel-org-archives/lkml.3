Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaA3APf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:15:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25491 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3APd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:15:33 -0500
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: konrad.wilk@oracle.com
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH V0] linux PVH: Set CR4 flags 
Date: Wed, 29 Jan 2014 16:15:17 -0800
Message-Id: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.7.2.3
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

The CR4 settings were dropped from my earlier patch because you didn't
wanna enable them. But since you do now, we need to set them in the APs
also. If you decide not too again, please apply my prev patch
"pvh: disable pse feature for now".

thanks
Mukesh

