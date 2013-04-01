Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3DAGrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:47:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64281 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3DAGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:47:11 -0400
Date: Sun, 31 Mar 2013 23:43:13 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrei Epure <epure.andrei@gmail.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/21] power: fix invalid free of devm_ allocated data
Message-ID: <20130401064312.GE13441@lizard>
References: <1364431919-26388-1-git-send-email-epure.andrei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364431919-26388-1-git-send-email-epure.andrei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 02:51:59AM +0200, Andrei Epure wrote:
> The objects allocated by devm_* APIs are managed by devres and are freed when
> the device is detached. Hence there is no need to use kfree() explicitly.
> Patch found using coccinelle.
> 
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---

Jingoo Han sent a similar change ealier... but thanks anyway!

Anton
