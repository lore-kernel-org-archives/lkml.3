Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbaGXMIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:08:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:34050 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382AbaGXMIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:08:12 -0400
Date: Thu, 24 Jul 2014 22:06:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Steve Grubb <sgrubb@redhat.com>,
        Dan Walsh <dwalsh@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] CAPABILITIES: remove undefined caps from all processes
In-Reply-To: <1406144186-23002-1-git-send-email-eparis@redhat.com>
Message-ID: <alpine.LRH.2.11.1407242206330.13682@namei.org>
References: <1406144186-23002-1-git-send-email-eparis@redhat.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Eric Paris wrote:

> This is effectively a revert of 7b9a7ec565505699f503b4fcf61500dceb36e744
> plus fixing it a different way...

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

-- 
James Morris
<jmorris@namei.org>

