Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaICBUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:20:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36449 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbaICBUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:20:02 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V2 PATCH 0/1] PVH: set EFER bits
Date: Tue,  2 Sep 2014 18:19:35 -0700
Message-Id: <1409707176-16487-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1:
   - Unify the patches into one
   - Unify the code to set the EFER bits.

thanks,
Mukesh

