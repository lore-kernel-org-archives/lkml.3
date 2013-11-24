Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3KXPV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 10:21:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41568 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3KXPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 10:21:55 -0500
Message-ID: <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 24 Nov 2013 10:21:50 -0500
In-Reply-To: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112415-7164-0000-0000-000003A0A152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Linus has already reverted the trusted keyring support for IMA patches.
These patches are re-based on -rc1.

The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:

  Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus

for you to fetch changes up to 3eeb2d63ab623be55bb2ff584e123c0df45691e3:

  ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-24 00:29:23 -0500)

thanks,

Mimi

----------------------------------------------------------------
Mimi Zohar (1):
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
 security/integrity/ima/ima.h              |  6 ++++--
 security/integrity/ima/ima_api.c          |  1 +
 security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
 security/integrity/ima/ima_fs.c           | 14 +++++++++++---
 security/integrity/ima/ima_template.c     | 10 ++++++++--
 security/integrity/ima/ima_template_lib.c | 24 +++++++++++++-----------
 7 files changed, 53 insertions(+), 25 deletions(-)


