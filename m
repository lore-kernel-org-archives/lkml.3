Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab3BHEE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:04:27 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40387 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab3BHEE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:04:26 -0500
MIME-Version: 1.0
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Date: Fri, 8 Feb 2013 14:04:24 +1000
Message-ID: <CAPM=9tznoedeBP5s8nd_kNubEwENKBtxoYtcL=UcC6T21Z9+wQ@mail.gmail.com>
Subject: Re: [PATCHSET] idr: deprecate idr_remova_all() and add idr_alloc()
From: Dave Airlie <airlied@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
> (If you're reading this patchset for the first time, this patchset is
>  an effort to improve idr interface.  This posting is mostly for
>  collecting and routing the patches towards -mm.  Please follow the
>  link at the end for details on each patchset.)
>
> Hello, Andrew.
>
> This patchset is combination of the following three on top of
> linux-next as of 20130204 (the one before idr_removal_all() got
> included).

just FYI, all the drm bits are

Acked-by: Dave Airlie <airlied@redhat.com>

Don't worry about attaching that to the patches though :-)

Dave.
