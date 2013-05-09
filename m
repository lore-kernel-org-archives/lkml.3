Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3EIVxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:53:05 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:38523 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab3EIVxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=fb/19I4vY5tGeeRCA5K
	OgSpdprsdlSmJhXnnTLDauknNeWhXroVYu4jjO1OgVRBIoT8SHdcizoOzJboN+oy
	QRe9A9qAleAmYf2oME7V4+MNIArSXOKHZKMzrN5ntBMMhEcCF3YysfdzZqlQdej0
	pSmfC3FkSwkRvvWPnQ6NHYAA=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.2.3
Date: Thu, 09 May 2013 14:53:00 -0700
Message-ID: <7v4neb95xf.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: D20E9176-B8F2-11E2-B148-E56BAAC0D69C-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.2.3 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

2831f7deec472db4d0d0cdffb4d82d91cecdf295  git-1.8.2.3.tar.gz
b8d6b3c4077d37b34bf08b6eb53c4ee5901fa2f9  git-htmldocs-1.8.2.3.tar.gz
eb04a2540ff9998e0887a4b862641ac1db723f3e  git-manpages-1.8.2.3.tar.gz

Also the following public repositories all have a copy of the v1.8.2.3
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

The original tarball location

    http://www.kernel.org/pub/software/scm/git/

will also have the source tarball, but not the preformatted
documentation tarballs.


Git v1.8.2.3 Release Notes
==========================

Fixes since v1.8.2.2
--------------------

 * "rev-list --stdin" and friends kept bogus pointers into the input
   buffer around as human readable object names.  This was not a
   huge problem but was exposed by a new change that uses these
   names in error output.

 * When "git difftool" drove "kdiff3", it mistakenly passed --auto
   option that was meant while resolving merge conflicts.

 * "git remote add" command did not diagnose extra command line
   arguments as an error and silently ignored them.

Also contains a handful of trivial code clean-ups, documentation
updates, updates to the test suite, etc.

----------------------------------------------------------------

Changes since v1.8.2.2 are as follows:

Anders Granskogen Bjørnstad (1):
      Documentation/git-commit: Typo under --edit

David Aguilar (1):
      mergetools/kdiff3: do not use --auto when diffing

Felipe Contreras (5):
      documentation: trivial whitespace cleanups
      complete: zsh: trivial simplification
      complete: zsh: use zsh completion for the main cmd
      completion: zsh: don't override suffix on _detault
      transport-helper: trivial style cleanup

John Keeping (1):
      t/Makefile: remove smoke test targets

Jonathan Nieder (1):
      glossary: a revision is just a commit

Junio C Hamano (1):
      Git 1.8.2.3

Ramkumar Ramachandra (3):
      git-completion.bash: lexical sorting for diff.statGraphWidth
      git-completion.bash: add diff.submodule to config list
      git-completion.bash: complete branch.*.rebase as boolean

René Scharfe (2):
      t5004: ignore pax global header file
      t5004: avoid using tar for checking emptiness of archive

Thomas Rast (4):
      read_revisions_from_stdin: make copies for handle_revision_arg
      remote: add a test for extra arguments, according to docs
      remote: check for superfluous arguments in 'git remote add'
      remote: 'show' and 'prune' can take more than one remote

