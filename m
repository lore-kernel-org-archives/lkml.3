Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbaLLHpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:45:44 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51636 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933905AbaLLHpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 02:45:24 -0500
MIME-Version: 1.0
In-Reply-To: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk>
From: Dave Vasilevsky <dave@vasilevsky.ca>
Date: Fri, 12 Dec 2014 02:44:52 -0500
X-Google-Sender-Auth: TfHXJME1r1cgc-IfFUpmADldd1U
Message-ID: <CAAoseZSoYbMRtd1jXEeRR0eSKUEWqgBw_=8+0PPkaDacZ+G6GA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        texstar@gmail.com, martin@mvath.de, Guan Xin <guanx.bac@gmail.com>,
        bruno@wolff.to, szycha@gmail.com, blyons@students.naropa.edu,
        tokiclover@gmail.com, afm404@gmail.com, hugochevrain@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to support the inclusion of these patches.

There's enough demand for LZ4-compressed squashfs that I received an
unsolicited patch adding support to my FUSE implementation,
squashfuse: https://github.com/vasi/squashfuse/pull/2

At least a few people are currently using squashfuse to mount their
LZ4-compressed squashfs images. Ideally these users would be able to
use the in-kernel squashfs for improved performance.

Cheers,
Dave Vasilevsky
