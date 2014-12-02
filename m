Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaLBSHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:07:48 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:55684 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaLBSHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:07:46 -0500
Date: Tue, 2 Dec 2014 13:07:43 -0500
From: Tejun Heo <tj@kernel.org>
To: nick <xerofoify@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fix me in libata-scsi.c
Message-ID: <20141202180743.GI10918@htj.dyndns.org>
References: <546A9EAC.4080509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546A9EAC.4080509@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 08:19:40PM -0500, nick wrote:
> I am wondering about the fix me in following code in the file listed
> in my message. Seems this is necessary from reading the code and the
> FIX ME is no longer needed as the memset is correct and needed for
> the function.

Yeah, I think the sense buffer clearing is the right thing regardless
of it being not strictly necessary for all devices.  There's no point
in not clearing it.  Please feel free to send a patch to remove the
comment.

Thanks.

-- 
tejun
