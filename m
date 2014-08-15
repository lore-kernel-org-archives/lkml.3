Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHOTLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:11:15 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35401 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaHOTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:11:10 -0400
Date: Fri, 15 Aug 2014 23:11:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, tj@kernel.org, akpm@linux-foundation.org,
        avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 0/4] prctl: set-mm -- Rework interface, v3
Message-ID: <20140815191107.GJ14878@moon>
References: <20140804172255.109539743@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804172255.109539743@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 09:22:55PM +0400, Cyrill Gorcunov wrote:
> Hi! Here is (I hope) a final version of the series (i've had a typo
> in check_data_rlimit helper, thanks serge.hallyn@ for spotting it).
> 
> Please take a look once time permit (and drop previous two verisions
> from mbox). Thanks!

Ping, any more comments?
