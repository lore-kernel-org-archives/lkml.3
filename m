Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaE3LiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:38:13 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:39776 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaE3LiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:38:12 -0400
Message-ID: <1401449890.4645.1.camel@leira.trondhjem.org>
Subject: Re: [PATCH] NFS: Use smp_mb__{before,after}_atomic()
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 May 2014 06:38:10 -0500
In-Reply-To: <1401440815-4227-1-git-send-email-thierry.reding@gmail.com>
References: <1401440815-4227-1-git-send-email-thierry.reding@gmail.com>
Organization: PrimaryData Inc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 11:06 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
> deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
> functions in favour of the unified smp_mb__{before,after}_atomic().

Where is this commit? It doesn't seem to have hit upstream yet.

-- 
Trond Myklebust
Linux NFS client maintainer, PrimaryData
trond.myklebust@primarydata.com


