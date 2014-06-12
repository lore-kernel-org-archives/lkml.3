Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaFLOpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:45:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:37977 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbaFLOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:45:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alin Dobre <alin.dobre@elastichosts.com>
Subject: Re: [RFC] Per-user namespace process accounting
Date: Thu, 12 Jun 2014 15:37:54 +0100
Message-ID: <5399BB42.60304@elastichosts.com>
References: <5386D58D.2080809@1h.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 79.135.116.105
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
In-Reply-To: <5386D58D.2080809@1h.com>
Cc: containers@lists.osdl.org, lxc-devel@lists.linuxcontainers.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/14 07:37, Marian Marinov wrote:
> Hello,
> 
> I have the following proposition.
> 
> Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that multiple
> containers in different user namespaces share the process counters.
> 
> So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any
> processes with ist own UID 99.
> 
> I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps, but
> this brings another problem.

If this matters, we also suffer from the same problem here. So we
support any implementation that would address it.

Cheers,
Alin.

