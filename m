Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3GSXnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:43:22 -0400
Received: from longford.logfs.org ([213.229.74.203]:59842 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3GSXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:43:20 -0400
Date: Fri, 19 Jul 2013 18:11:43 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mit@purestorage.com
Subject: Re: [PATCH] mpt2sas: don't handle broadcast primitives
Message-ID: <20130719221143.GG29404@logfs.org>
References: <20130719220659.GF29404@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130719220659.GF29404@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 July 2013 18:06:59 -0400, Jörn Engel wrote:
> 
> The handling of broadcast primitives involves
> _scsih_block_io_all_device(), which does what the name implies.  I have
> observed cases with >60s of blocking io on all devices, caused by a
> single bad device.  The downsides of this code are obvious, while the
> upsides are more elusive.

And since this patch looks more like an April fools joke: I have
gathered a few machine-months of testing, including tortures that
specifically stress the removed codepaths.  This is a serious
submission and unless someone can show me a _very_ good reason for
keeping the deleted code, I would like to get it merged.

Jörn

--
Computer system analysis is like child-rearing; you can do grievous damage,
but you cannot ensure success."
-- Tom DeMarco
