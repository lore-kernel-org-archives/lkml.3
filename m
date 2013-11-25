Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3KYUd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:33:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:33380 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KYUdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:33:55 -0500
Message-ID: <1385411631.2357.5.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL v3] ima: bug fixes for Linus
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2013 15:33:51 -0500
In-Reply-To: <52939AEE.5070809@polito.it>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>
	 <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>
	 <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
	 <52939AEE.5070809@polito.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112520-1542-0000-0000-0000039BA503
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Included in this pull request, is Roberto's updated patch.  I've
included a Changelog.

The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:

  Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus

for you to fetch changes up to dbc335d2dc3c437649eb6b39f4e9aee2a13eb0af:

  ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-25 15:05:33 -0500)

thanks,

Mimi

----------------------------------------------------------------
Roberto Sassu (3):
      ima: do not include field length in template digest calc for ima template
      ima: do not send field length to userspace for digest of ima template
      ima: make a copy of template_fmt in template_desc_init_fields()

 security/integrity/ima/ima.h              |  6 ++++--
 security/integrity/ima/ima_api.c          |  1 +
 security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
 security/integrity/ima/ima_fs.c           | 14 +++++++++++---
 security/integrity/ima/ima_template.c     | 21 ++++++++++++++-------
 security/integrity/ima/ima_template_lib.c |  6 +++++-
 6 files changed, 47 insertions(+), 18 deletions(-)

----------------------------------------------------------------
Roberto Sassu (3):
      ima: do not include field length in template digest calc for ima
template
      ima: do not send field length to userspace for digest of ima
template
      ima: make a copy of template_fmt in template_desc_init_fields()

 security/integrity/ima/ima.h              |  6 ++++--
 security/integrity/ima/ima_api.c          |  1 +
 security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
 security/integrity/ima/ima_fs.c           | 14 +++++++++++---
 security/integrity/ima/ima_template.c     | 21 ++++++++++++++-------
 security/integrity/ima/ima_template_lib.c |  6 +++++-
 6 files changed, 47 insertions(+), 18 deletions(-)


