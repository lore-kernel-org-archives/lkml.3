Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbbATPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:45:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52287 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbATPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:45:25 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <20150120150419.46c6d430@canb.auug.org.au>
References: <20150120150419.46c6d430@canb.auug.org.au>
Date: Tue, 20 Jan 2015 10:45:24 -0500
Message-ID: <CAHC9VhSmmK_UKr_ssByKKhwED+nSZ_6XjE1TtFTExg_dSN2Uag@mail.gmail.com>
Subject: Re: linux-next: manual merge of the audit tree with Linus' tree
From: Paul Moore <paul@paul-moore.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 11:04 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Paul,
>
> Today's linux-next merge of the audit tree got a conflict in
> include/linux/audit.h between commit 041d7b98ffe5 ("audit: restore
> AUDIT_LOGINUID unset ABI") from Linus' tree and commit e80da768eae4
> ("audit: remove vestiges of vers_ops") from the audit tree.

I suspect rebasing the audit next branch will resolve this issue as well.

-- 
paul moore
www.paul-moore.com
