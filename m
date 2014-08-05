Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaHEIMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:12:19 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39760 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbaHEIMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:12:15 -0400
Date: Tue, 5 Aug 2014 12:12:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        akpm@linux-foundation.org, avagin@openvz.org, ebiederm@xmission.com,
        hpa@zytor.com, serge.hallyn@canonical.com, xemul@parallels.com,
        segoon@openwall.com, kamezawa.hiroyu@jp.fujitsu.com,
        mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-ID: <20140805081211.GM20553@moon>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.965949916@openvz.org>
 <20140805080852.GA32222@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805080852.GA32222@paralelels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 12:08:53PM +0400, Andrew Vagin wrote:
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Andrew Vagin <avagin@openvz.org>
> 
> Acked-by: Andrew Vagin <avagin@openvz.org>
> 
> I have tested this patch with criu. Everything work as expected.

Thanks Andrew, Serge!
