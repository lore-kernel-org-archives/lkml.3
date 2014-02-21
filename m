Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaBULkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:40:16 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36886 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbaBULkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:40:14 -0500
Message-ID: <53073B1A.3040709@gmail.com>
Date: Fri, 21 Feb 2014 12:40:10 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: BUG: unable to handle kernel paging request at 0000000100000003 -
 Oops: 0000 [#1] SMP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Affected kernels - 3.14.0-0.rc3*:

- 3.14.0-0.rc3.git0.1
  http://koji.fedoraproject.org/koji/buildinfo?buildID=498711

- 3.14.0-0.rc3.git0.7 based on 3.14.0-0.rc3.git0.1

- 3.14.0-0.rc3.git2.1
  http://koji.fedoraproject.org/koji/buildinfo?buildID=499061

- 3.14.0-0.rc3.git5.1
  http://koji.fedoraproject.org/koji/buildinfo?buildID=499636

Memtest86+ 4.20 - OK
http://goo.gl/1nm1nV

RHBZ
https://bugzilla.redhat.com/show_bug.cgi?id=1067919

messages-Oops-es-3.14.0-0.rc3
https://bugzilla.redhat.com/attachment.cgi?id=865926


poma

