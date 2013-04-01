Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3DAGk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:40:57 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54867 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3DAGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:40:56 -0400
Date: Sun, 31 Mar 2013 23:36:57 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power: 88pm860x: fix invalid free of devm_* allocated
 data
Message-ID: <20130401063656.GB13441@lizard>
References: <1363501123-14350-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363501123-14350-1-git-send-email-silviupopescu1990@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 08:18:43AM +0200, Silviu-Mihai Popescu wrote:
> The objects allocated by devm_* APIs are managed by devres and are freed
> when the device is detached. There is no need to use kfree() explicitly.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---

Jingoo Han sent a similar patch earlier...

Anyway, thanks!

Anton
