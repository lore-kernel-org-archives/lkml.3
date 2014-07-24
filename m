Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbaGXR5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:57:50 -0400
Received: from smtp.pobox.com ([208.72.237.35]:51456 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759505AbaGXR5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:57:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=LfOrkIeRsKTJXFoxo/p
	L9u8TrwWnSLtA3nqjVXRAZTttOhqKxiRLbf3P23ZXvTy4RH+PMOztcAijQLABTgV
	YYKtvqcSRCOexjT3e/lDD5+h0csqfQT9y6Xi1ifl0SZauxBjLuH4YJFzI+gehavX
	vj8yA3vuSMJb3Ko5HxJzKwUc=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v2.0.3
Date: Thu, 24 Jul 2014 10:57:33 -0700
Message-ID: <xmqqa97yabci.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: FE2E9F66-135B-11E4-93FA-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v2.0.3 is now available at
the usual places.  Hopefully it would be the final maintenance
release for the v2.0 series.

The tarballs are found at:

    https://www.kernel.org/pub/software/scm/git/

The following public repositories all have a copy of the 'v2.0.3'
tag and the 'maint' branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v2.0.3 Release Notes
========================

 * An ancient rewrite passed a wrong pointer to a curl library
   function in a rarely used code path.

 * "filter-branch" left an empty single-parent commit that results when
   all parents of a merge commit gets mapped to the same commit, even
   under "--prune-empty".

 * "log --show-signature" incorrectly decided the color to paint a
   mergetag that was and was not correctly validated.

 * "log --show-signature" did not pay attention to "--graph" option.

Also a lot of fixes to the tests and some updates to the docs are
included.

----------------------------------------------------------------

Changes since v2.0.2 are as follows:

Abbaad Haider (1):
      http-push.c: make CURLOPT_IOCTLDATA a usable pointer

Ben Walton (1):
      compat/bswap.h: fix endianness detection

Brian Gesiak (12):
      builtin/ls-remote.c: rearrange xcalloc arguments
      builtin/remote.c: rearrange xcalloc arguments
      commit.c: rearrange xcalloc arguments
      config.c: rearrange xcalloc arguments
      diff.c: rearrange xcalloc arguments
      http-push.c: rearrange xcalloc arguments
      imap-send.c: rearrange xcalloc arguments
      notes.c: rearrange xcalloc arguments
      pack-revindex.c: rearrange xcalloc arguments
      reflog-walk.c: rearrange xcalloc arguments
      remote.c: rearrange xcalloc arguments
      transport-helper.c: rearrange xcalloc arguments

Charles Bailey (2):
      compat/bswap.h: detect endianness on more platforms that don't use BYTE_ORDER
      filter-branch: eliminate duplicate mapped parents

Elia Pinto (1):
      scripts: "export VAR=VALUE" construct is not portable

Jeremiah Mahler (3):
      Documentation: wording fixes in the user manual and glossary
      t/t7810-grep.sh: remove duplicate test_config()
      api-strbuf.txt minor typos

Johannes Sixt (1):
      fix brown paper bag breakage in t5150-request-pull.sh

Jonathan McCrohan (1):
      git-instaweb: add support for Apache 2.4

Junio C Hamano (3):
      compat/bswap.h: restore preference __BIG_ENDIAN over BIG_ENDIAN
      scripts: more "export VAR=VALUE" fixes
      Git 2.0.3

Michael J Gruber (1):
      log: correctly identify mergetag signature verification status

Philip Oakley (1):
      doc: give some guidelines for error messages

René Scharfe (2):
      use xcalloc() to allocate zero-initialized memory
      use xmemdupz() to allocate copies of strings given by start and length

Stefan Beller (2):
      git.1: switch homepage for stats
      .mailmap: combine Stefan Beller's emails

Stepan Kasal (1):
      t5000, t5003: do not use test_cmp to compare binary files

Yi EungJun (1):
      http-protocol.txt: Basic Auth is defined in RFC 2617, not RFC 2616

Zoltan Klinger (1):
      log: fix indentation for --graph --show-signature

brian m. carlson (1):
      Documentation: fix missing text for rev-parse --verify

