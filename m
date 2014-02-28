Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaB1PBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:01:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27744 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaB1PBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:34 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fa-5310a4ccc7df
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/8] integrity: fixes and new features
Date: Fri, 28 Feb 2014 16:59:24 +0200
Message-id: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xa7pnlggEGzzcxGVxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSujZf9htoKfnBWrN81iamD8yt7FyMkhIWAiMevXfShbTOLC
	vfVsXYxcHEICSxklTnT2skM4nUwSFy8cA6tiE9CT2ND8A8wWEXCWWHSrnRWkiFlgKqPEq1vT
	WEASwgJmEvfvvQWzWQRUJV7samLqYuTg4BWwlHj9rA5im4LEsi9rmScwci9gZFjFKJpamlxQ
	nJSea6RXnJhbXJqXrpecn7uJERIsX3cwLj1mdYhRgINRiYdXYpFAsBBrYllxZe4hRgkOZiUR
	3kuLgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYL/a9O1bymP1yZ9/tnqJ32zmNzJrM2MIbmPN0
	69SVXqhKzXwncsLY78bD7T+XPEvh9gmpO9CXdT0nRujkgeX/IsOMXHy8v3na9i4J2XB87mLL
	WeuX/BQoehPsfblFQVhll8Dyv8WlbjKblst/+yM4bd3Vul9zd85uyN3BoJAnseTT5Oansve0
	lViKMxINtZiLihMBsJDGbPQBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset contains bug fixes, cleanups and new features
for integrity subsytem.

- Dmitry

Dmitry Kasatkin (8):
  ima: fix erronous removal of security.ima xattr
  integrity: fix checkpatch errors
  ima: return d_name.name if d_path fails
  evm: EVM does not use MD5
  ima: skip memory allocation for empty files
  evm: enable key retention service automatically
  evm: introduce EVM hmac attribute list
  evm: introduce EVM hmac xattr list

 security/integrity/evm/Kconfig        | 35 +++++++++-----
 security/integrity/evm/evm.h          | 41 +++++++++-------
 security/integrity/evm/evm_crypto.c   | 14 +++---
 security/integrity/evm/evm_main.c     | 90 +++++++++++++++++++++--------------
 security/integrity/iint.c             |  2 +-
 security/integrity/ima/ima_api.c      | 10 ++--
 security/integrity/ima/ima_crypto.c   | 22 +++++----
 security/integrity/ima/ima_fs.c       |  6 +--
 security/integrity/ima/ima_main.c     | 11 ++---
 security/integrity/ima/ima_policy.c   | 75 +++++++++++++++--------------
 security/integrity/ima/ima_queue.c    |  4 +-
 security/integrity/ima/ima_template.c | 14 +++---
 security/integrity/integrity_audit.c  |  4 +-
 13 files changed, 183 insertions(+), 145 deletions(-)

-- 
1.8.3.2

