Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3KVSk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:40:29 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58104 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3KVSkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:40:25 -0500
Message-ID: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: [GIT PULL] ima: bug fixes for Linus
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 22 Nov 2013 13:40:21 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112218-1542-0000-0000-00000389224F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

The following changes since commit 217091dd7a7a1bdac027ddb7c5a25f6ac0b8e241:

  ima: define '_ima' as a builtin 'trusted' keyring (2013-10-31 20:20:48 -0400)

are available in the git repository at:

  ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git ima-fixes-new

for you to fetch changes up to 0fdb4f5d9a07a832b38ebbc616a19411700d1fac:

  ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-22 13:08:31 -0500)

thanks,

Mimi

----------------------------------------------------------------
Mimi Zohar (4):
      ima: fix random config build error
      ima: limit trusted keyring name change
      KEYS: special dot prefixed keyring name bug fix
      ima: update IMA-templates.txt documentation

Roberto Sassu (7):
      ima: change the default hash algorithm to SHA1 in ima_eventdigest_ng_init()
      ima: pass HASH_ALGO__LAST as hash algo in ima_eventdigest_init()
      ima: remove unneeded size_limit argument from ima_eventdigest_init_common()
      ima: check result of crypto_shash_update() in ima_calc_field_array_hash_tfm
      ima: do not include field length in template digest calc for ima template
      ima: do not send field length to userspace for digest of ima template
      ima: make a copy of template_fmt in template_desc_init_fields()

 Documentation/security/IMA-templates.txt  |  6 ++++--
 security/integrity/digsig.c               | 12 ++++--------
 security/integrity/ima/ima.h              |  6 ++++--
 security/integrity/ima/ima_api.c          |  1 +
 security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
 security/integrity/ima/ima_fs.c           | 14 +++++++++++---
 security/integrity/ima/ima_template.c     | 10 ++++++++--
 security/integrity/ima/ima_template_lib.c | 24 +++++++++++++-----------
 security/integrity/integrity.h            | 11 +++++------
 security/keys/keyctl.c                    | 11 ++++++++++-
 10 files changed, 72 insertions(+), 40 deletions(-)


