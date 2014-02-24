Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBXWAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:18 -0500
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:50466 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752160AbaBXWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:973:988:989:1260:1345:1437:1534:1543:1711:1730:1747:1777:1792:1801:2393:2559:2562:2894:2910:3138:3139:3140:3141:3142:3353:3866:4605:5007:6114:6261:6642:8557:10004:10026:10848:11658:11914:12043:12517:12519:12679:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: milk05_1f3e6b20d5a33
X-Filterd-Recvd-Size: 3660
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        selinux@tycho.nsa.gov
Subject: [PATCH 0/8] security: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:53 -0800
Message-Id: <cover.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly trivial cleanups of security modules

Joe Perches (8):
  security: Use a more current logging style
  security: apparmor: Use a more current logging style
  security: integrity: Use a more current logging style
  security: keys: Use a more current logging style
  security: selinux: Use a more current logging style
  security: smack: Use a more current logging style
  security: tomoyo: Use a more current logging style
  security: yama: Use a more current logging style

 security/apparmor/apparmorfs.c           |   2 +
 security/apparmor/crypto.c               |   2 +
 security/apparmor/include/apparmor.h     |   2 +-
 security/apparmor/lib.c                  |   4 +-
 security/apparmor/lsm.c                  |   2 +
 security/apparmor/match.c                |   5 +-
 security/apparmor/policy.c               |   2 +
 security/apparmor/procattr.c             |   2 +
 security/capability.c                    |  16 ++--
 security/commoncap.c                     |  15 ++--
 security/integrity/evm/evm_crypto.c      |   4 +-
 security/integrity/evm/evm_main.c        |   6 +-
 security/integrity/evm/evm_secfs.c       |   6 +-
 security/integrity/ima/ima_crypto.c      |   4 +-
 security/integrity/ima/ima_init.c        |   5 +-
 security/integrity/ima/ima_queue.c       |   8 +-
 security/integrity/ima/ima_template.c    |   5 +-
 security/keys/encrypted-keys/encrypted.c |  70 ++++++++---------
 security/keys/encrypted-keys/encrypted.h |   2 +-
 security/keys/key.c                      |   2 +
 security/keys/trusted.c                  |  42 +++++-----
 security/keys/trusted.h                  |  20 ++---
 security/security.c                      |   4 +-
 security/selinux/avc.c                   |   7 +-
 security/selinux/hooks.c                 | 130 +++++++++++++------------------
 security/selinux/netif.c                 |  14 ++--
 security/selinux/netlink.c               |   5 +-
 security/selinux/netnode.c               |   6 +-
 security/selinux/netport.c               |   7 +-
 security/selinux/selinuxfs.c             |  19 ++---
 security/selinux/ss/avtab.c              |  39 +++++-----
 security/selinux/ss/conditional.c        |  18 +++--
 security/selinux/ss/ebitmap.c            |  21 +++--
 security/selinux/ss/policydb.c           | 109 ++++++++++++--------------
 security/selinux/ss/services.c           | 101 ++++++++++--------------
 security/selinux/ss/sidtab.c             |   8 +-
 security/smack/smack_lsm.c               |   7 +-
 security/smack/smackfs.c                 |  25 +++---
 security/tomoyo/common.c                 |  23 +++---
 security/tomoyo/domain.c                 |   8 +-
 security/tomoyo/load_policy.c            |   9 ++-
 security/tomoyo/memory.c                 |   7 +-
 security/tomoyo/tomoyo.c                 |   4 +-
 security/tomoyo/util.c                   |   7 +-
 security/yama/yama_lsm.c                 |  18 ++---
 45 files changed, 404 insertions(+), 418 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

