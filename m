Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbbAGGTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:19:50 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:51485 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbbAGGTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:19:49 -0500
Date: Wed, 7 Jan 2015 07:19:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc32: nocheck uaccess coding style tweaks
Message-ID: <20150107061935.GB844@ravnborg.org>
References: <1420582149-23235-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420582149-23235-1-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 12:10:18AM +0200, Michael S. Tsirkin wrote:
> Sam Ravnborg suggested packing single-lines cases in switch statements
> in nocheck uaccess macros makes for easier to read code.
> 
> Suggested-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
