Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaB1Cpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:45:49 -0500
Received: from tundra.namei.org ([65.99.196.166]:50298 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaB1Cps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:45:48 -0500
Date: Fri, 28 Feb 2014 13:53:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org, Nicolas Schichan <nschichan@freebox.fr>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>, josh@joshtriplett.org
Subject: Re: [PATCH 35/46] kernel: Mark function as static in
 kernel/seccomp.c
In-Reply-To: <76266614ae965cacc59033bd20385fbcf6393770.1393493277.git.rashika.kheria@gmail.com>
Message-ID: <alpine.LRH.2.02.1402281353470.26521@tundra.namei.org>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com> <76266614ae965cacc59033bd20385fbcf6393770.1393493277.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Rashika Kheria wrote:

> Mark function as static in kernel/seccomp.c because it is not used
> outside this file.
> 
> This eliminates the following warning in kernel/seccomp.c:
> kernel/seccomp.c:296:6: warning: no previous prototype for ?seccomp_attach_user_filter? [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
