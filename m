Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3BFOsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:48:25 -0500
Received: from ozlabs.org ([203.10.76.45]:59052 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab3BFOsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:48:17 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
Subject: [PATCH 0/3 v3] selftests: Add efivarfs tests
Message-Id: <1360162088.142733.191120808822.0.gpush@pecola>
In-Reply-To: <1360162088.142733.191120808822.0.gpush@pecola>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Wed, 06 Feb 2013 22:48:08 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patches add a small set of tests to the
tools/testing/selftests directory. These cover some of the basic
functionality of efivarfs.

Comments welcome - changes 2 and 3 cover some behaviour that Matt and I
have discussed, but I'd appreciate any wider comment on the semantics
covered by these.

Cheers,


Jeremy

--
v2: Remove qemu check, add a couple of tests
v3: Change expected empty read() behaviour to return EOF

---
Jeremy Kerr (3):
      selftests: Add tests for efivarfs
      selftests/efivarfs: Add empty file creation test
      selftests/efivarfs: Add create-read test

