Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaFMRQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:16:31 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:43034
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbaFMRQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:16:30 -0400
Date: Fri, 13 Jun 2014 12:16:27 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
In-Reply-To: <1402590209-31610-6-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.10.1406131215330.1717@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-6-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Tejun Heo wrote:

> +#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
> +#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))

At the conclusion of the current &get_cpu_var patchset these two
definitions are scheduled to be removed.

Otherwise this looks good.

