Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaFMRSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:18:10 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:34027
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbaFMRSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:18:08 -0400
Date: Fri, 13 Jun 2014 12:18:06 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] percpu: only allow sized arch overrides for
 {raw|this}_cpu_*() ops
In-Reply-To: <1402590209-31610-7-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.10.1406131217200.1717@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-7-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Tejun Heo wrote:

> This patch removes the support for whole operation overrides.  As no
> arch is using it, this doesn't cause any actual difference.

Acked-by: Christoph Lameter <cl@linux.com>
