Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3LCVwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:52:05 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:33945 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3LCVvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=t9Q3CKJWFIcEXHYvzn1SLmbZODQHwiRJQK1zjfxaGYEYPDob+3qsjxa7
	+urJJZBYBmPzYS65FOHyVfrK8jtPoxDMyqAta0m5acJOJL9pTjveGSj0ucz4mn0v
	omAPtfCv+46g2SO23VyhNmrZDcPFQV1Jd1J9ZLJljPW835ayl7A=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.4.5
Date: Tue, 03 Dec 2013 13:48:11 -0800
Message-ID: <xmqq38m9mwlr.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 1ACEE06C-5C65-11E3-9BFA-D331802839F8-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A maintenance release Git v1.8.4.5 is now available at the
usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

b43c0cc46749ad62b8ac74237ceca00c8e386edb  git-1.8.4.5.tar.gz
bd66db8c9528e53d2b93e88ef8e96164e597333f  git-htmldocs-1.8.4.5.tar.gz
1ff6380e60c879a563ef89452ca461e9610e41c0  git-manpages-1.8.4.5.tar.gz

The following public repositories all have a copy of the v1.8.4.5
tag and the maint-1.8.4 branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Also, http://www.kernel.org/pub/software/scm/git/ has copies of the
release tarballs.

Git v1.8.4.5 Release Notes
==========================

Fixes since v1.8.4.4
--------------------

 * Recent update to remote-hg that attempted to make it work better
   with non ASCII pathnames fed Unicode strings to the underlying Hg
   API, which was wrong.

 * "git submodule init" copied "submodule.$name.update" settings from
   .gitmodules to .git/config without making sure if the suggested
   value was sensible.

----------------------------------------------------------------

Changes since v1.8.4.4 are as follows:

Junio C Hamano (2):
      submodule: do not copy unknown update mode from .gitmodules
      Git 1.8.4.5

Richard Hansen (1):
      remote-hg: don't decode UTF-8 paths into Unicode objects

