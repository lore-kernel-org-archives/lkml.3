Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaA1CS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:18:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41233 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaA1CSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:18:55 -0500
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: konrad.wilk@oracle.com
Cc: roger.pau@citrix.com, Xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: pvh: disable pse feature for now
Date: Mon, 27 Jan 2014 18:18:38 -0800
Message-Id: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.7.2.3
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

Following will turn off PSE in linux until we can get to it. It's better
to turn it off here than in xen, so if BSD gets there sooner, they are not 
dependent on us.

thanks
Mukesh

