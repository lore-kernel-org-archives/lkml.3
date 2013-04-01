Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3DAGml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:42:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46538 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3DAGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:42:40 -0400
Date: Sun, 31 Mar 2013 23:38:41 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] drivers: power: goldfish: use resource_size()
Message-ID: <20130401063841.GC13441@lizard>
References: <1363507294-19958-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363507294-19958-1-git-send-email-silviupopescu1990@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 10:01:34AM +0200, Silviu-Mihai Popescu wrote:
> This uses the resource_size() function instead of explicit computation.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---

Applied, thanks!

Anton
