Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaDRQol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:44:41 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:34245 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbaDRQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:44:37 -0400
Date: Fri, 18 Apr 2014 11:44:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
In-Reply-To: <20140418154918.GD4523@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.10.1404181143390.9558@gentwo.org>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <20140418154918.GD4523@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014, Michal Hocko wrote:

> Auto-enabling caused so many reports in the past that it is definitely
> much better to not be clever and let admins enable zone_reclaim where it
> is appropriate instead.
>
> For both patches.
> Acked-by: Michal Hocko <mhocko@suse.cz>

I did not get any objections from SGI either.

Reviewed-by: Christoph Lameter <cl@linux.com>

