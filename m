Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaKCVST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:18:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaKCVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:18:17 -0500
Date: Mon, 3 Nov 2014 13:18:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141103211816.GA7379@kroah.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 12:42:48PM -0800, Stephanie Wallick wrote:
> +#define DEBUG

I doubt you want this in the driver enabled by default :(

