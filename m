Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbbAFU6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:58:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbbAFU6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:58:52 -0500
Date: Tue, 6 Jan 2015 21:58:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Christoph Jaeger <cj@linux.com>
cc: jpoimboe@redhat.com, sjenning@redhat.com, vojtech@suse.cz,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] livepatch: kconfig: use bool instead of
 boolean
In-Reply-To: <1420515249-4848-1-git-send-email-cj@linux.com>
Message-ID: <alpine.LNX.2.00.1501062158340.25732@pobox.suse.cz>
References: <1420515249-4848-1-git-send-email-cj@linux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, Christoph Jaeger wrote:

> Keyword 'boolean' for type definition attributes is considered deprecated and
> should not be used anymore. No functional changes.
> 
> Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> Reference: http://lkml.kernel.org/r/1419108071-11607-1-git-send-email-cj@linux.com
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
