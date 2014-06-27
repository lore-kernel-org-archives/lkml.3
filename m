Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaF0XlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:41:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54275 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbaF0XlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:41:02 -0400
X-Sasl-enc: JLobSPXU/x5or4JWN4wmM2WkBoIdXWDgATHmqf86WczA 1403912461
Date: Fri, 27 Jun 2014 16:45:11 -0700
From: Greg KH <greg@kroah.com>
To: Yue Zhang <yuezha@microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        olaf@aepfle.de, jasowang@redhat.com, apw@canonical.com,
        huishao@microsoft.com
Subject: Re: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Message-ID: <20140627234511.GA1044@kroah.com>
References: <1403914608-21604-1-git-send-email-yuezha@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403914608-21604-1-git-send-email-yuezha@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 05:16:48PM -0700, Yue Zhang wrote:
> From: Yue Zhang <yuezha@microsoft.com>
> 
> hv_fcopy_daemon fails to overwrite a file if the target file already
> exits.
> 
> Add O_TRUNC flag on opening.
> 
> MS-TFS: 341345

It's as if the people on your team don't talk to each other about what
they should, or should not, include in their patch descriptions...

Please remove.

greg k-h
