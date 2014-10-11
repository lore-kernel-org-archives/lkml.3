Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaJKUWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 16:22:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaJKUWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 16:22:33 -0400
Date: Sat, 11 Oct 2014 13:21:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] serial: sh-sci: use dmaengine_terminate_all() API
Message-ID: <20141011202132.GB29591@kroah.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-9-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413042040-28222-9-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 09:10:37PM +0530, Vinod Koul wrote:
> The drivers should use dmaengine_terminate_all() API instead of
> accessing the device_control which will be deprecated soon
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
