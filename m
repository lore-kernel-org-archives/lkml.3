Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3KYNvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:51:19 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40257 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3KYNvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:51:16 -0500
Message-ID: <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2013 08:51:10 -0500
In-Reply-To: <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>
	 <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>
	 <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112513-0928-0000-0000-00000401D864
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

These are the "essential fixes for regressions".

The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:

  Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus

for you to fetch changes up to 72ca1bd303a5126d0ce377cff699282b6b38bd86:

  ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-25 07:32:46 -0500)

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
 security/integrity/ima/ima_template.c     | 10 ++++++++--
 security/integrity/ima/ima_template_lib.c |  6 +++++-
 6 files changed, 41 insertions(+), 13 deletions(-)


