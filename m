Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab3FTQ3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:29:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34625 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397Ab3FTQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:29:38 -0400
Message-ID: <51C32DEF.1060209@wwwdotorg.org>
Date: Thu, 20 Jun 2013 10:29:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Michal Marek <mmarek@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/7] metag: add <dt-bindings/> symlink
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com> <1371729758-10196-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1371729758-10196-2-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 06:02 AM, James Hogan wrote:
> Add symlink to include/dt-bindings from arch/metag/boot/dts/include/ to
> match the one in arch/arm/... (see the commit below) so that
> preprocessed device tree files can include various useful constant
> definitions.
> 
> Commit c58299aa87544a590c62bda0bf52b69fa56cb8d5 ("kbuild: create an
> "include chroot" for DT bindings") merged in v3.10-rc1.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
