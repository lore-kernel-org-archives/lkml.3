Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3BOTEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:04:37 -0500
Received: from sauhun.de ([89.238.76.85]:39295 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3BOTEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:04:36 -0500
Date: Fri, 15 Feb 2013 20:04:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: Re: i2c/i2c-mxs: use devm_request_and_ioremap
Message-ID: <20130215190432.GA27970@the-dreams.de>
References: <1359850497-927-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359850497-927-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 02:14:57PM -0000, =?utf-8?q?Peter_H=C3=BCwe_=3CPeterHuewe=40gmx=2Ede=3E?= wrote:

> Replace a call to devm_request_mem_region followed by a call to
> dev_ioremap_nocache with devm_request_and_ioremap which does the same.
> And since res_size isn't needed anymore we can remove it as well.

Since this is the only change, we better wait for devm_ioremap_resource
in 3.9.

