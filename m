Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3KTWG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:06:56 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:51145 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab3KTWGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:06:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=aBYP6GZpWGrC79YFZ42H0AqiuKfnEohV3lFCn/H7ZGitELr5fR4OYhRI
	Op3SC1CZQmQugTuT60UdzZE4URGNS5aKjjQG3SiHoMlFPCKyqWhA3E04qRpHgydW
	TZm65WxgTsJ1MyF4EOlmXgSwbMyVK+dtGI91av5pzsWHKwSsYJA=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.4.4
Date: Wed, 20 Nov 2013 14:06:48 -0800
Message-ID: <xmqqd2lu7mo7.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 0E892A36-5230-11E3-BE74-D331802839F8-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.4.4 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

1aaa1a51b599f19125e06fa6e839c9ff2e5ac941  git-1.8.4.4.tar.gz
c2ee47c2bbf8ede70eef2a1ba936a30aa0d78b2a  git-htmldocs-1.8.4.4.tar.gz
4637e22fd2fe59cf00b4a105f5104af9bfea8c2c  git-manpages-1.8.4.4.tar.gz

The following public repositories all have a copy of the v1.8.4.4
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Also, http://www.kernel.org/pub/software/scm/git/ has copies of the
release tarballs.

Git v1.8.4.4 Release Notes
========================

Fixes since v1.8.4.3
--------------------

 * The fix in v1.8.4.3 to the pack transfer protocol to propagate
   the target of symbolic refs broke "git clone/git fetch" from a
   repository with too many symbolic refs. As a hotfix/workaround,
   we transfer only the information on HEAD.

----------------------------------------------------------------

Changes since v1.8.4.3 are as follows:

Junio C Hamano (2):
      Revert "upload-pack: send non-HEAD symbolic refs"
      Git 1.8.4.4

