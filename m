Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaESN33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:29:29 -0400
Received: from tex.lwn.net ([70.33.254.29]:55459 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaESN32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:29:28 -0400
Date: Mon, 19 May 2014 07:29:26 -0600
From: Jake Edge <jake@lwn.net>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/06] staging: crypto: skein: rename files
Message-ID: <20140519072926.3a05fe08@chukar.edge2.net>
In-Reply-To: <a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
	<abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
	<dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
	<cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
	<b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
	<2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
	<a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 12:09:59 +0400 Anton Saraev wrote:

> rename drivers/staging/skein/{skeinBlockNo3F.c =>
> skein_block_no_3f.c} (99%)

fwiw, this file (skeinBlockNo3F.c) seems to be unused ... it kind of looks
like a temporary file that got checked in by mistake.  It's probably worth
deleting it in this patch or a separate one, it seems to me.

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
