Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbbAAVXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:23:47 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34960 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbAAVXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:23:45 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 1 Jan 2015 22:23:44 +0100
Message-ID: <CA+icZUUkp4OrPWfw7PEpt2DDEyrf+z1SAQcXpREOXoA7JQ0stg@mail.gmail.com>
Subject: libaio tarballs on <kernel.org>
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillem Jover <guillem@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC libaio Debian/Ubuntu maintainer ]

Hi Jeff,

I am playing with fio (manually compiled v2.2.3) and wanted to update
also my libaio development package on Ubuntu/precise.

Both dsc (description) files of Debian and Ubuntu libaio source
packages v0.3.110 [1,2] point to a URL on <kernel.org> [3].
This space is empty.

Google told me about [4].

My question: Where does someone get official libaio tarballs?

Thanks in advance.

Regards,
- Sedat -

[0.1] http://brick.kernel.dk/snaps/fio-2.2.3.tar.bz2
[0.2] http://git.kernel.org/cgit/linux/kernel/git/axboe/fio.git/tree/README#n101
[1] http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_0.3.110-1.dsc
[2] http://archive.ubuntu.com/ubuntu/pool/main/liba/libaio/libaio_0.3.110-1.dsc
[3] https://www.kernel.org/pub/linux/libs/aio/
[4] https://git.fedorahosted.org/cgit/libaio.git/
