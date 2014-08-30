Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaH3TTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 15:19:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42738 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbaH3TTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 15:19:47 -0400
X-Sasl-enc: Y4V1nNahIGCyIBl10Na1Oz+3GXQuVhNRVxWrC5q0ftgC 1409426386
Date: Sat, 30 Aug 2014 12:19:45 -0700
From: Greg KH <greg@kroah.com>
To: "John L. Hammond" <john.hammond@intel.com>
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] staging/lustre flatten some headers
Message-ID: <20140830191945.GA12501@kroah.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 06:35:08PM -0500, John L. Hammond wrote:
> This series removes several headers from lustre/include/linux by
> taking whatever was worthwhile from linux/lustre_barf.h and moving it
> to lustre_barf.h or to wherever it's needed.

Very nice, all now applied, thanks.

greg k-h
