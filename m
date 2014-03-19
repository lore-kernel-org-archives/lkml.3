Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaCSVi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:38:28 -0400
Received: from s15279694.onlinehome-server.info ([87.106.27.49]:42761 "EHLO
	bender.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaCSVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:38:26 -0400
Date: Wed, 19 Mar 2014 22:37:54 +0100
From: Max Kellermann <mk@cm4all.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/namespace: don't clobber mnt_hash.next while
 umounting
Message-ID: <20140319213754.GA25719@rabbit.intern.cm-ag>
Mail-Followup-To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
References: <20140319212226.25520.98808.stgit@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319212226.25520.98808.stgit@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/03/19 22:22, Max Kellermann <mk@cm4all.com> wrote:
> +			list_add(&child->mnt_unmounted, &mnt->mnt_hash);

This is obviously a bug in my patch, sorry.  Will resend a fixed
patch.
