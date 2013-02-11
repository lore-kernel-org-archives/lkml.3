Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab3BKSiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:38:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab3BKSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:38:52 -0500
Date: Mon, 11 Feb 2013 13:38:48 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the hierarchy
Message-ID: <20130211183847.GG30962@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
 <20130209040402.GA31942@mail.hallyn.com>
 <20130211143241.GF30962@redhat.com>
 <20130211174259.GA18179@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211174259.GA18179@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 05:42:59PM +0000, Serge E. Hallyn wrote:
> Note I said only forbid behavior changes - not exception changes - to
> cgroups with children.

that won't do much. behavior change is the simplest: if you change a
behavior, you wipe the local exceptions unless the special (deny, deny)
-> (allow, deny) case.
exception propagation is harder
getting rid of local settings would buy more simplicity

-- 
Aristeu

