Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaDAIl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:41:28 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56781 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbaDAIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:41:25 -0400
Message-ID: <1396341683.21634.13.camel@x220>
Subject: Re: Build regressions/improvements in v3.14
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 10:41:23 +0200
In-Reply-To: <1396339078-22125-1-git-send-email-geert@linux-m68k.org>
References: <1396339078-22125-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2014 08:41:23.0669 (UTC) FILETIME=[29A55050:01CF4D86]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 09:57 +0200, Geert Uytterhoeven wrote:
>   + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
>   + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
>   + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]:  => 511:17

See, for the (unsophisticated) solution currently being discussed,
https://lkml.org/lkml/2014/3/4/124 .

>   + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 773:18

Fix should be included in target-pending/for-next, see
https://lkml.org/lkml/2014/2/20/476 .

>   + /scratch/kisskb/src/net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1774:1

This one could already be seen in v3.8. Anyhow, it's being tracked at
https://bugzilla.kernel.org/show_bug.cgi?id=68661 .



Paul Bolle

