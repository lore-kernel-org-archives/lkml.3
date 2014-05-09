Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaEIUAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:00:14 -0400
Received: from smtp.pobox.com ([208.72.237.35]:52304 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbaEIUAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=Rhl3LbQb8UVIcKW5iap
	xHy5fz+Rkp3wCZXWFGteE9uaAiFinK3XQ6ev3R6fyzltBYcdsIiXHSKPFcX4HBYa
	0gzAdtlDFvXvkeI6Ljfr5y8qH6ES7pUlyq1hNvj6ywoZGdrEwetG5VhwEJQBo0F4
	7GkBzi6uS8hPZUnz28i6vwpE=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.9.3
Date: Fri, 09 May 2014 13:00:08 -0700
Message-ID: <xmqq38giyb7b.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 86536F54-D7B4-11E3-A6FB-9CEB01674E00-77302942!pb-smtp0.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.9.3 is now available at
the usual places.

The tarballs are found at:

    https://www.kernel.org/pub/software/scm/git/testing/

The following public repositories will all have a copy of the
'v1.9.3' tag and the 'maint' branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

but I am cutting 2.0.0-rc3 today, so you may have to wait for a bit
until these repositories are updated.


Git v1.9.3 Release Notes
========================

Fixes since v1.9.2
------------------

 * "git p4" dealing with changes in binary files were broken by a
   change in 1.9 release.

 * The shell prompt script (in contrib/), when using the PROMPT_COMMAND
   interface, used an unsafe construct when showing the branch name in
   $PS1.

 * "git rebase" used a POSIX shell construct FreeBSD /bin/sh does not
   work well with.

 * Some more Unicode codepoints defined in Unicode 6.3 as having
   zero width have been taught to our display column counting logic.

 * Some tests used shell constructs that did not work well on
   FreeBSD.

----------------------------------------------------------------

Changes since v1.9.2 are as follows:

Jonathan Nieder (1):
      shell doc: remove stray "+" in example

Junio C Hamano (2):
      Start preparing for 1.9.3
      Git 1.9.3

Kyle J. McKay (4):
      test: fix t7001 cp to use POSIX options
      test: fix t5560 on FreeBSD
      rebase: avoid non-function use of "return" on FreeBSD
      Revert "rebase: fix run_specific_rebase's use of "return" on FreeBSD"

Richard Hansen (1):
      git-prompt.sh: don't put unsanitized branch names in $PS1

Tolga Ceylan (1):
      git-p4: format-patch to diff-tree change breaks binary patches

Torsten Bögershausen (1):
      utf8.c: partially update to version 6.3

