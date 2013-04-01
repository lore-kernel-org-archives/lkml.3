Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3DAGiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:38:20 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:44188 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3DAGiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:38:19 -0400
Date: Sun, 31 Mar 2013 23:34:20 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: lp8788: use PAGE_SIZE for the sysfs read operation
Message-ID: <20130401063420.GA13441@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F82E48A0E@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E48A0E@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:19:29AM +0000, Kim, Milo wrote:
> The sysfs allocates PAGE_SIZE. It is used by each R/W operation method.
> Use it instead of another buffer size.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---

Applied, thanks!

Anton
