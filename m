Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaFFNvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:51:05 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:54627 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFFNvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:51:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [fuse-devel] [PATCH 0/5] fuse: close file synchronously (v2)
From: John Muir <john@jmuir.com>
In-Reply-To: <20140606132541.30321.68679.stgit@localhost.localdomain>
Date: Fri, 6 Jun 2014 15:51:01 +0200
Cc: miklos@szeredi.hu, fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E5474E5C-B6FC-459C-ACCE-F6871221D45E@jmuir.com>
References: <20140606132541.30321.68679.stgit@localhost.localdomain>
To: Maxim Patlasov <mpatlasov@parallels.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.06.06, at 15:27 , Maxim Patlasov <mpatlasov@parallels.com> wrote:

> The patch-set resolves the problem by making fuse_release synchronous:
> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.

Why not make this feature per-file with a new flag bit in struct fuse_file_info rather than as a file-system global?

John.

--
John Muir - john@jmuir.com
+32 491 64 22 76

