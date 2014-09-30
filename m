Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaI3S7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:59:41 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:38880 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaI3S7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:59:39 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2014 14:59:39 EDT
Date: Tue, 30 Sep 2014 19:50:11 +0100
From: Mark Einon <mark@einon.net>
To: Karthik Nayak <karthik.188@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gamerh2o@gmail.com, gregkh@linuxfoundation.org, mark.einon@gmail.com
Subject: Re: [PATCH] staging: et131x: remove unneccessary 'out of memory'
 message
Message-ID: <20140930185011.GA1982@msilap.einon.net>
References: <1412099743-3893-1-git-send-email-karthik.188@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412099743-3893-1-git-send-email-karthik.188@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:25:43PM +0530, Karthik Nayak wrote:
> Removes the 'out of memory' warning issued by checkpatch
> 
> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
> ---

Hi,

I'm not sure which tree you're working agianst, but this change has already
been made and is on both staging-next and linux-next.

Cheers,

Mark
