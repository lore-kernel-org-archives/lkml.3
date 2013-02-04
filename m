Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3BDPRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:17:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab3BDPRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:17:14 -0500
Date: Mon, 4 Feb 2013 09:17:05 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 9/9] devcg: propagate local changes down the hierarchy
Message-ID: <20130204151705.GA7211@sergelap>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130201190958.GP17632@redhat.com>
 <20130202161341.GA11284@mail.hallyn.com>
 <20130204150307.GQ17632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204150307.GQ17632@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> hm, no. I think you misunderstood "local.behavior = DEVCG_DEFAULT_NONE".
> This means "there's no local preference for behavior". local.* are just
> the local preferences that need to be revalidated everytime something is
> propagated. Or did you mean something else?

Ah, yes, I didn't understand that correctly, thanks.

-serge
