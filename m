Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3KLHc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:32:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3KLHcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:32:23 -0500
Date: Mon, 11 Nov 2013 16:19:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131112001902.GA1043@kroah.com>
References: <1383875883-30597-1-git-send-email-ohaugan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383875883-30597-1-git-send-email-ohaugan@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 05:58:03PM -0800, Olav Haugan wrote:
> zsmalloc encodes a handle using the pfn and an object
> index. On hardware platforms with physical memory starting
> at 0x0 the pfn can be 0. This causes the encoded handle to be
> 0 and is incorrectly interpreted as an allocation failure.

Please list the known hardware platforms that have this issue, so that
people have a chance to know if this patch is relevant for them or not.

For example, should I include this in the stable releases because it
affects systems that are shipping?  Or is it just in "future" chips and
it doesn't need to go there or not?

Please make it easy for me to do this type of determination, I already
asked you this question before, why didn't you include the information
here as well (hint, that is why I asked you...)

greg k-h
