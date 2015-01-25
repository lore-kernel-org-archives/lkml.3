Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbbAYQQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:16:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbbAYQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:16:09 -0500
Date: Sun, 25 Jan 2015 21:34:33 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, vkuznets@redhat.com
Subject: Re: [PATCH RESEND 1/5] Tools: hv: add mising fcopyd to the Makefile
Message-ID: <20150125133433.GA2708@kroah.com>
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
 <1420870735-2265-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420870735-2265-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 10:18:51PM -0800, K. Y. Srinivasan wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> fcopyd in missing in the Makefile, add it there.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

This patch fails to apply :(
