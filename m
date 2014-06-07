Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaFGTo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 15:44:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38764 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaFGTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 15:44:56 -0400
Date: Sat, 7 Jun 2014 22:44:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: tidspbridge: pmgr: dspapi.c: Cleaning up
 uninitialized variable
Message-ID: <20140607194436.GB5500@mwanda>
References: <1401834219-30682-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401834219-30682-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 12:23:39AM +0200, Rickard Strandqvist wrote:
> There is a risk that the variables will be used without being initialized.
> Has also improved error handling, after an email proposal from Dan Carpenter.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Looks ok.  This fixes some information leak bugs.  Thanks.

regards,
dan carpenter

