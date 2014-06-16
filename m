Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaFPPbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:31:32 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:39200
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbaFPPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:31:28 -0400
Date: Mon, 16 Jun 2014 10:31:26 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
In-Reply-To: <alpine.DEB.2.11.1406131354210.24349@gentwo.org>
Message-ID: <alpine.DEB.2.11.1406161029250.20878@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-6-git-send-email-tj@kernel.org> <alpine.DEB.2.10.1406131215330.1717@gentwo.org> <20140613182538.GB3723@htj.dyndns.org> <alpine.DEB.2.11.1406131354210.24349@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Christoph Lameter wrote:

> > Yeah, dropping that part isn't difficult.  Where's the &get_cpu_var
> > patchset now?  Is it gonna make it into v3.16-rc1?
>
> Pieces are flowing in for that through various trees. I can post the
> remaining patches once v3.16 is out.

Just went through it. About 30 patches still left. Some of the subsystems
that indicated acceptance did not merge the patches. Guess I will patch
the whole thing and make my rounds again. Or could we get this through the
percpu tree?


