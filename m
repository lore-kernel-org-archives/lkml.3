Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3EaR10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:27:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45641 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3EaR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:27:20 -0400
Message-ID: <51A8DD74.8090403@wwwdotorg.org>
Date: Fri, 31 May 2013 11:27:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: make sure we clean up DTB temporary files
References: <1369995261-20735-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1369995261-20735-1-git-send-email-ian.campbell@citrix.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 04:14 AM, Ian Campbell wrote:
> Various temporary files used when building DTB files were not suffixed with
> .tmp and therefore were not cleaned up by "make clean".

Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

