Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaARC0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 21:26:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36718 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaARCZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 21:25:35 -0500
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: konrad.wilk@oracle.com
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [V0 PATCH] xen/pvh: set some cr flags upon vcpu start
Date: Fri, 17 Jan 2014 18:24:54 -0800
Message-Id: <1390011895-28123-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.7.2.3
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

The following patch sets the bits in CR0 and CR4. Please note, I'm working
on patch for the xen side. The CR4 features are not currently exported
to a PVH guest. 

Roger, I added your SOB line, please lmk if I need to add anything else.

This patch was build on top of a71accb67e7645c68061cec2bee6067205e439fc in
konrad devel/pvh.v13 branch.

thanks
Mukesh


