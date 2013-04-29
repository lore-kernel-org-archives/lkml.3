Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3D2Lib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:38:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32685 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3D2Li2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:38:28 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: carsten@schiers.de, darren.s.shepherd@gmail.com, david.vrabel@citrix.com,
        ian.campbell@citrix.com, ian.jackson@eu.citrix.com,
        james-xen@dingwall.me.uk, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH v2 0/2] xen/balloon: Extension and fix
Date: Mon, 29 Apr 2013 13:37:46 +0200
Message-Id: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are extension and fix for balloon driver:
  - xen/balloon: Notify a host about a guest memory size limit,
  - xen/balloon: Enforce various limits on target.

They are posted as a reference for libxl memory management patches
which I posted today. Please do not apply them yet.

Daniel

