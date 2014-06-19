Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544AbaFSVHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:07:50 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:58849 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965418AbaFSVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:07:49 -0400
Date: Thu, 19 Jun 2014 16:07:47 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
In-Reply-To: <20140618181620.GB11042@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406191606340.5484@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-6-git-send-email-tj@kernel.org> <alpine.DEB.2.10.1406131215330.1717@gentwo.org> <20140613182538.GB3723@htj.dyndns.org> <alpine.DEB.2.11.1406131354210.24349@gentwo.org>
 <alpine.DEB.2.11.1406161029250.20878@gentwo.org> <20140618181620.GB11042@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Tejun Heo wrote:

> On Mon, Jun 16, 2014 at 10:31:26AM -0500, Christoph Lameter wrote:
> > Just went through it. About 30 patches still left. Some of the subsystems
> > that indicated acceptance did not merge the patches. Guess I will patch
> > the whole thing and make my rounds again. Or could we get this through the
> > percpu tree?
>
> If the maintainers agree (or nobody cares), sure.

Ok I ran randconfig on it for a day. Seems to be fine now (at least on x86
no guarantee for other arches though). I can post that when I got some
time.


