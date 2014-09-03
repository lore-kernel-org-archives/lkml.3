Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbaICHcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:32:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64504 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaICHc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:32:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-bb-5406c40a113f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/3] integrity: build scripts changes
Date: Wed, 03 Sep 2014 10:29:26 +0300
Message-id: <cover.1409728926.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xK7pcR9hCDBZv0re49Xcvs8WXpXUW
	L2fMY7e4vGsOm8WHnkdsFp9WTGJ2YPPYOesuu8eDQ5tZPHYv+Mzk0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBlPWrYzF1xhrXi6eh1jA+Npli5GTg4JAROJRRN/Q9liEhfurWfrYuTiEBJY
	yihx53A3K4TTySSxYNk8dpAqNgE9iQ3NP8BsEYEciUlnLjCD2MwC6RKfJvWCxYUFLCS+PVjE
	CGKzCKhKbN2ykamLkYODV8BSomlnGcQyOYmTxyazTmDkXsDIsIpRNLU0uaA4KT3XSK84Mbe4
	NC9dLzk/dxMjJDC+7mBceszqEKMAB6MSD2+EIFuIEGtiWXFl7iFGCQ5mJRFe30SgEG9KYmVV
	alF+fFFpTmrxIUYmDk6pBsZF/RMkBb/8nH+c3ZDdbmpjz44JHAoWvEsNDv67uU3qeMbvdd9m
	beNJmLQkLIaX5SvXYzb5Fx77f+k/dGs/NHH7BZsNlxVfaBdvPnTAyPLbDM/yv4xXg3//5Gae
	Ycdx4+Kv48dbqxcbbHfs6V1/fUXGHX3mRZwypz/8XZ8hdawlX/nv8qeX9VO1lFiKMxINtZiL
	ihMBC6/wheoBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches introduce few changes to integrity subsystem build scripts.
Patch descriptions provide detailed explanations.

Changes in v2:
- use 'menu' instead of 'menuconfig' to keep integrity as security option

- Dmitry

Dmitry Kasatkin (3):
  integrity: move asymmetric keys config option
  integrity: move integrity subsystem options to a separate menu
  integrity: make all integrity components as integrity module

 security/integrity/Kconfig     | 38 ++++++++++++++++++++++++--------------
 security/integrity/Makefile    |  6 +++---
 security/integrity/evm/Kconfig |  9 +--------
 security/integrity/ima/Kconfig |  3 +--
 4 files changed, 29 insertions(+), 27 deletions(-)

-- 
1.9.1

