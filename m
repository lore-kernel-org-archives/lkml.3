Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaLBSAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:00:42 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52463 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBSAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:00:41 -0500
Date: Tue, 2 Dec 2014 13:00:37 -0500
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>, Joe Perches <joe@perches.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sata_fsl: fix error handling of irq_of_parse_and_map
Message-ID: <20141202180037.GG10918@htj.dyndns.org>
References: <20141114213905.GA25228@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114213905.GA25228@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 01:39:05PM -0800, Dmitry Torokhov wrote:
> irq_of_parse_and_map() returns 0 on error (the result is unsigned int),
> so testing for negative result never works.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

Sorry about the delay.  Applied to libata/for-3.18-fixes w/ stable
cc'd.

Thanks.

-- 
tejun
