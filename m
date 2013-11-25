Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3KYUlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:41:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3KYUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:41:13 -0500
Date: Mon, 25 Nov 2013 12:41:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 0/1] staging: zsmalloc: Ensure handle is never 0 on
 success
Message-ID: <20131125204112.GA22606@kroah.com>
References: <1385141441-16446-1-git-send-email-ohaugan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385141441-16446-1-git-send-email-ohaugan@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:30:40AM -0800, Olav Haugan wrote:
> v3:
> Updated commit text with info about affected SoCs.

You forgot to add a Cc: stable tag :(

I'll go do it...

