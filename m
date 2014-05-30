Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbaE3Vwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:52:40 -0400
Received: from smtp.pobox.com ([208.72.237.35]:51728 "EHLO smtp.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbaE3Vwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=nZu8estDdx//d0xbp6DN7zyzRpF1TSiVIEopk8GV8N5LjsxccGXBKQ+Z
	dItuo0fMIfZhJTw1zNqSJfpJcwixE37vPv7EXcW/WBGQTzk1cUGT8gkCwjbi8pk/
	KTNyFj4LJKvyubPoMFeFHRxWRMlDvd0jEInLcIgRbVcAocZZ1Xg=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.9.4
Date: Fri, 30 May 2014 14:52:32 -0700
Message-ID: <xmqqmwdz6ijj.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: B4EF274A-E844-11E3-8731-9903E9FBB39C-77302942!pb-smtp0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A maintenance release Git v1.9.4 is now available at the usual
places.  This is expected to be the final maintenance release for
the 1.9 series, merging the remaining fixes that are relevant and
are already in 2.0.

The tarballs are found at:

    https://www.kernel.org/pub/software/scm/git/

The following public repositories all have a copy of the 'v1.9.4'
tag and the 'maint-1.9' branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Git v1.9.4 Release Notes
========================

Fixes since v1.9.3
------------------

 * Commands that take pathspecs on the command line misbehaved when
   the pathspec is given as an absolute pathname (which is a
   practice not particularly encouraged) that points at a symbolic
   link in the working tree.

 * An earlier fix to the shell prompt script (in contrib/) for using
   the PROMPT_COMMAND interface did not correctly check if the extra
   code path needs to trigger, causing the branch name not to appear
   when 'promptvars' option is disabled in bash or PROMPT_SUBST is
   unset in zsh.
