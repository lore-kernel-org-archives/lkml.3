Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbbAGGTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:19:01 -0500
Received: from asavdk4.altibox.net ([109.247.116.15]:58992 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbAGGTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:19:00 -0500
Date: Wed, 7 Jan 2015 07:18:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc64: minor coding style tweaks
Message-ID: <20150107061841.GA844@ravnborg.org>
References: <1420580314-15107-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420580314-15107-1-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:39:59PM +0200, Michael S. Tsirkin wrote:
> Sam Ravnborg suggested packing single-line cases
> in nocheck switch statements makes for easier to
> read code.
> 
> This is on top of arch/sparc: uaccess_64 macro whitespace fixes
> that I sent earlier.
> 
> Suggested-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
