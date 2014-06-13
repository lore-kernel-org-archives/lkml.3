Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaFMRNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:13:42 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:33099 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbaFMRNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:13:42 -0400
Date: Fri, 13 Jun 2014 12:13:40 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] percpu: move accessors from include/linux/percpu.h
 to percpu-defs.h
In-Reply-To: <1402590209-31610-5-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.10.1406131213220.1717@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-5-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Tejun Heo wrote:

> so that arch headers can make use of them too without worrying about
> circular dependency through include/linux/percpu.h.

Acked-by: Christoph Lameter <cl@linux.com>
