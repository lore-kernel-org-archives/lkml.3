Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaFMRWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:22:16 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:41703
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbaFMRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:22:15 -0400
Date: Fri, 13 Jun 2014 12:22:13 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] percpu: use raw_cpu_*() to define __this_cpu_*()
In-Reply-To: <1402590209-31610-11-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.10.1406131221550.1717@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-11-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Tejun Heo wrote:

> Let's layer them so that __this_cpu_*() are defined in terms of
> raw_cpu_*().  It's simpler and less error-prone this way.

Acked-by: Christoph Lameter <cl@linux.com>

