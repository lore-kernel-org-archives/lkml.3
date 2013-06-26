Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3FZI52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:57:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39858 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3FZI50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:57:26 -0400
Date: Wed, 26 Jun 2013 09:57:20 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-mpidr tree with the arm tree
Message-ID: <20130626085719.GA22333@e102568-lin.cambridge.arm.com>
References: <20130626110411.d1fe3913769385fa056010be@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20130626110411.d1fe3913769385fa056010be@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 26 Jun 2013 08:57:23.0033 (UTC) FILETIME=[2C386490:01CE724B]
X-MC-Unique: 113062609572401801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jun 26, 2013 at 02:04:11AM +0100, Stephen Rothwell wrote:
> Hi Lorenzo,
> 
> Today's linux-next merge of the arm-mpidr tree got a conflict in
> arch/arm/kernel/suspend.c between commit 7604537bbb57 ("ARM: kernel:
> implement stack pointer save array through MPIDR hashing") from the arm
> tree and commit 3fed6a1e3bf0 ("ARM: kernel: implement stack pointer save
> array through MPIDR hashing") from the arm-mpidr tree.
> 
> The former is just a rebase of the latter, so I used it.  It then turns
> out that the arm-mpidr contains nothing that is not already included in
> the arm tree, so is it needed any more i.e. is there further work coming?

No, arm-mpidr can be dropped from -next now that those patches, as you
correctly mentioned, are queued through the arm tree.

Thank you very much indeed,
Lorenzo

