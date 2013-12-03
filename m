Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3LCVvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:51:49 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:63903 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab3LCVvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:51:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id:mime-version:content-type; q=dns; s=
	sasl; b=Bci1H6Ex4V+5sjpDpKs0bXZifgIq97+ETqbCWw69MoNu+zNP9UkWm9ER
	nxM3j3A9u9PJtTX1nj5UQ7ZOV/Qt8bQ15wt8FnO4jYd10P8ER19WoVCHMTB3b9VY
	PiXlVhR+50xYv9z/OiLhJXc2m/+nAJZHQ3iCsWpUA4k54RUaRKY=
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Git v1.8.5.1
Date: Tue, 03 Dec 2013 13:47:49 -0800
Message-ID: <xmqq8uw1mwmb.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 18EE1C5E-5C65-11E3-8B4D-D331802839F8-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git v1.8.5.1 is now available at
the usual places.

The release tarballs are found at:

    http://code.google.com/p/git-core/downloads/list

and their SHA-1 checksums are:

dcd244c7198e8afe42ab223f7b3c9b1ae01749c3  git-1.8.5.1.tar.gz
16cd5fdf486aa880c4fcb297d769070c67996317  git-htmldocs-1.8.5.1.tar.gz
32befa65b564640981d71f8a38eee19939a2eb63  git-manpages-1.8.5.1.tar.gz

The following public repositories all have a copy of the v1.8.5.1
tag and the maint branch that the tag points at:

  url = https://kernel.googlesource.com/pub/scm/git/git
  url = git://repo.or.cz/alt-git.git
  url = https://code.google.com/p/git-core/
  url = git://git.sourceforge.jp/gitroot/git-core/git.git
  url = git://git-core.git.sourceforge.net/gitroot/git-core/git-core
  url = https://github.com/gitster/git

Also, http://www.kernel.org/pub/software/scm/git/ has copies of the
release tarballs.

Git v1.8.5.1 Release Notes
==========================

Fixes since v1.8.5
------------------

 * "git submodule init" copied "submodule.$name.update" settings from
   .gitmodules to .git/config without making sure if the suggested
   value was sensible.

----------------------------------------------------------------

Changes since v1.8.5 are as follows:

Junio C Hamano (3):
      submodule: do not copy unknown update mode from .gitmodules
      Git 1.8.4.5
      Git 1.8.5.1

Nick Townsend (1):
      ref-iteration doc: add_submodule_odb() returns 0 for success

