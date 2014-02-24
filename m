Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaBXDho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:37:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:39369 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaBXDhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:37:42 -0500
Date: Mon, 24 Feb 2014 14:45:23 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Joe Perches <joe@perches.com>
cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] capability: Use current logging styles
In-Reply-To: <1393021170.2594.24.camel@joe-AO722>
Message-ID: <alpine.LRH.2.02.1402241445000.19008@tundra.namei.org>
References: <1393021170.2594.24.camel@joe-AO722>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Joe Perches wrote:

> Prefix logging output with "capability: " via pr_fmt.
> Convert printks to pr_<level>.
> Use pr_<level>_once instead of guard flags.
> Coalesce formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next



-- 
James Morris
<jmorris@namei.org>
