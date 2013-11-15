Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3KOFq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:46:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3KOFqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:46:12 -0500
Date: Fri, 15 Nov 2013 13:26:51 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 01/39] staging/lustre/hsm: remove hsm_nl proc file
Message-ID: <20131115042651.GA18697@kroah.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
 <1384446782-13741-2-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384446782-13741-2-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:32:24AM +0800, Peng Tao wrote:
> From: "John L. Hammond" <john.hammond@intel.com>
> 
> Remove the file /proc/fs/lustre/mdc/*/hsm_nl which was introduced "for
> testing purposes."

What does this mean?  Why is this allowed?  How do you know no one uses
it?  I need a much better changelog comment here, sorry.

greg k-h
