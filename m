Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab3BLSW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:22:26 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38998 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933470Ab3BLSWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:22:25 -0500
Message-ID: <1360693342.5128.39.camel@joe-AO722>
Subject: Re: [PATCH V4 1/2] get_maintainer: allow keywords to match filenames
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Date: Tue, 12 Feb 2013 10:22:22 -0800
In-Reply-To: <511A8743.9010408@wwwdotorg.org>
References: <1360629574-23989-1-git-send-email-swarren@wwwdotorg.org>
	 <1360649875.5128.18.camel@joe-AO722> <511A8743.9010408@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 11:17 -0700, Stephen Warren wrote:
> On 02/11/2013 11:17 PM, Joe Perches wrote:
> > If the -f pattern is a single file,
> > get_maintainer reads that file content and then
> > matches any K: patterns.
> > 
> > When the -f pattern is a directory, it doesn't.
> 
> Yes, I guess that's true; I had convinced myself that "file" wasn't
> accurate since "-f directory/" didn't scan the files within that
> directory tree, but as you say "-f file" does scan the file content.
> 
> BTW, given I'm adding "filename" to the list, I intend to change the
> existing "file" to "file content" to be clear. Are you OK with that?

Sure.

