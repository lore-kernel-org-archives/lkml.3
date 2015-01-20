Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbbATVEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:04:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbATVEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:04:01 -0500
Date: Wed, 21 Jan 2015 05:03:50 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jake Oshins <jakeo@microsoft.com>
Cc: kys@microsoft.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Subject: Re: [PATCH 1/1] drivers:hv:vmbus Allow for more than one MMIO range
 for children.
Message-ID: <20150120210350.GA13258@kroah.com>
References: <y>
 <1421791180-18810-1-git-send-email-jakeo@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421791180-18810-1-git-send-email-jakeo@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:59:40PM -0800, Jake Oshins wrote:
> Signed-off-by: Jake Oshins <jakeo@microsoft.com>

No changelog body explaining why this is needed and what it fixes?

Please redo.
