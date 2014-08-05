Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaHELOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:14:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32426 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaHELON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:14:13 -0400
Date: Tue, 5 Aug 2014 14:13:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christoph Jaeger <email@christophjaeger.info>
Cc: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] staging: ozwpan: Simplify app interface
Message-ID: <20140805111351.GT4856@mwanda>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
 <1407156896-3246-7-git-send-email-email@christophjaeger.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407156896-3246-7-git-send-email-email@christophjaeger.info>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 02:54:52PM +0200, Christoph Jaeger wrote:
> Simplify the somewhat overcomplicated application interface; improves
> readability and saves a bunch of lines.
> 
> Use designated struct initializers for clarity.

I was worried this would change the API but it doesn't.  The patch looks
ok.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

