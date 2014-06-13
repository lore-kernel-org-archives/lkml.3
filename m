Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaFMRMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:12:55 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:51060
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbaFMRMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:12:54 -0400
Date: Fri, 13 Jun 2014 12:12:52 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] percpu: include/asm-generic/percpu.h should contain
 only arch-overridable parts
In-Reply-To: <1402590209-31610-4-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.10.1406131212320.1717@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-4-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Tejun Heo wrote:

> Let's clear up the situation by making include/asm-generic/percpu.h
> contain only arch-overridable parts and moving accessors and
> operations into include/linux/percpu-defs.  Note that this patch only
> moves things from include/asm-generic/percpu.h.
> include/linux/percpu.h will be taken care of by later patches.

Acked-by: Christoph Lameter <cl@linux.com>
