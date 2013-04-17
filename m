Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966858Ab3DQPpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:45:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53568 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965236Ab3DQPpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:45:17 -0400
Message-ID: <516EC1D6.6010205@wwwdotorg.org>
Date: Wed, 17 Apr 2013 09:37:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] metag: avoid unnecessary builtin dtb rebuilds
References: <1366192975-14953-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1366192975-14953-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 04:02 AM, James Hogan wrote:
> The builtin .dtb.S intermediate file needs to be marked with .SECONDARY
> so that it isn't automatically deleted (which causes it to be
> regenerated on every build). Also add *.dtb.S to clean-files so it gets
> cleaned up by make clean.
> 
> Similarly, if the specified builtin dtb isn't already in dtb-y (e.g.
> imported into the tree and specified in CONFIG_METAG_BUILTIN_DTB_NAME)
> it too will be treated as an intermediate and deleted automatically
> (again causing it to be regenerated on every build), so add it to dtb-y
> so it gets added to targets and the dtbs target.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
