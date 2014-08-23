Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaHWQAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 12:00:09 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:47593
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbaHWQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 12:00:08 -0400
Date: Sat, 23 Aug 2014 11:00:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH 07/15] percpu: make percpu-km set chunk->populated bitmap
 properly
In-Reply-To: <1408726399-4436-8-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.11.1408231059470.29970@gentwo.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org> <1408726399-4436-8-git-send-email-tj@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Tejun Heo wrote:

> percpu-km instantiates the whole chunk on creation and doesn't make
> use of chunk->populated bitmap and leaves it as zero.  While this
> currently doesn't cause any problem, the inconsistency makes it
> difficult to build further logic on top of chunk->populated.  This
> patch makes percpu-km fill chunk->populated on creation so that the
> bitmap is always consistent.

Acked-by: Christoph Lameter <cl@linux.com>
