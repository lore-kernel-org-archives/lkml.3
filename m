Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3A3Spi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:45:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab3A3Spg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:45:36 -0500
Date: Wed, 30 Jan 2013 13:45:32 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 1/9] device_cgroup: prepare exception list handling
 functions for two lists
Message-ID: <20130130184531.GI17632@redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.321644928@napanee.usersys.redhat.com>
 <20130130174140.GA6411@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130174140.GA6411@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 05:41:40PM +0000, Serge E. Hallyn wrote:
> Quoting aris@redhat.com (aris@redhat.com):
> > In the following patches, device_cgroup structure will have two sets of
> > behavior and exceptions list (actual one, another with the local settings)
> > so rework the functions to use exception list, not a device_cgroup.
> > 
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> 
> Hi,
> 
> near as I can tell this is identical to the one I acked on Nov 20?

argh, yes. sorry about that.

-- 
Aristeu

