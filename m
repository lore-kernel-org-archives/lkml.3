Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBRSvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:51:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaBRSvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:51:41 -0500
Date: Tue, 18 Feb 2014 10:53:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/2] Fix missing misc nodes
Message-ID: <20140218185306.GD29209@kroah.com>
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:27:23AM -0300, Lucas De Marchi wrote:
> From: Lucas De Marchi <lucas.demarchi@intel.com>
> 
> These patches are not intended for merging as is... clearly we have at least
> one problem: fram's minor is clashing with logibm's. I don't know what to do
> here.
> 
> The first patch also adds comments on those minors that are defined but not
> used. Is that ok?

Yes, that's fine, thanks, I'll queue that one up.

greg k-h
