Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3LKNky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:40:54 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51937 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3LKNkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:40:51 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2] of: unflatten_and_copy: handle NULL initial_boot_params
To: James Hogan <james.hogan@imgtec.com>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <528E0F7F.7010901@imgtec.com>
References: <1385041454-32385-1-git-send-email-james.hogan@imgtec.com> < 528E0F7F.7010901@imgtec.com>
Date: Wed, 11 Dec 2013 13:40:43 +0000
Message-Id: <20131211134043.ACED0C4061A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 13:49:51 +0000, James Hogan <james.hogan@imgtec.com> wrote:
> On 21/11/13 13:44, James Hogan wrote:
> > Check whether initial_boot_params is NULL before dereferencing it in
> > unflatten_and_copy_device_tree() for the case where no device tree is
> > available but the arch can still boot to a minimal usable system without
> > it. In this case also log a warning for when the kernel log buffer is
> > obtainable.
> > 
> > Signed-off-by: James Hogan <james.hogan@imgtec.com>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: devicetree@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> 
> Hmm, sorry, I forgot to add Grant's:
> Acked-by: Grant Likely <grant.likely@linaro.org>
> 
> (from v1)

Applied, thanks.

g.

