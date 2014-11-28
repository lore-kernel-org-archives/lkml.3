Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbaK1MXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:23:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaK1MXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:23:43 -0500
Date: Fri, 28 Nov 2014 13:23:40 +0100
From: Michal Marek <mmarek@suse.cz>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile: sort list of defconfig targets in make help
 output
Message-ID: <20141128122340.GA21552@sepie.suse.cz>
References: <20141028141820.14137.64256.stgit@buzz>
 <546B3599.7080806@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B3599.7080806@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:03:37PM +0300, Konstantin Khlebnikov wrote:
> On 2014-10-28 16:18, Konstantin Khlebnikov wrote:
> >Without sorting this list is completely unreadable for ARCH=arm.
> 
> Bump.

Applied to kbuild.git#kbuild now, sorry for the delay.

Michal
