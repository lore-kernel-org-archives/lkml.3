Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3JYVai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:30:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63863 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751749Ab3JYVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:30:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PowerCap: Convert class code to use dev_groups
Date: Fri, 25 Oct 2013 23:42:37 +0200
Message-ID: <2163165.eG5ajaNixF@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131023155905.GA6976@kroah.com>
References: <1382528255-12781-1-git-send-email-treding@nvidia.com> <20131023155905.GA6976@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 04:59:05 PM Greg Kroah-Hartman wrote:
> On Wed, Oct 23, 2013 at 01:37:35PM +0200, Thierry Reding wrote:
> > The newly added power capping framework uses the obsolete .dev_attrs
> > field of struct class. However this field will be removed in 3.13, so
> > convert the code to use the .dev_groups field instead.
> > 
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied, thanks!

