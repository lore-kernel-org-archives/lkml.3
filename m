Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaBKNBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:01:11 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53157 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbaBKNBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:01:10 -0500
Message-ID: <1392123668.13064.23.camel@x220>
Subject: Re: [PATCH] staging: r8188eu: default to "y" in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Richard Weinberger <richard@nod.at>,
        Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 14:01:08 +0100
In-Reply-To: <20140211125306.GW26722@mwanda>
References: <1392121892.13064.9.camel@x220> <20140211125306.GW26722@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 13:01:09.0574 (UTC) FILETIME=[5553EE60:01CF2729]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 15:53 +0300, Dan Carpenter wrote:
> You've pretty much given Martin's secret assistance away already on a
> public mailing list.  Next time just add the Reported-by.  :P

I would have done, if I hadn't bothered to check
Documentation/SubmittingPatches first. It contains:
   Please note that this tag should not be added without the reporter's
   permission, especially if the problem was not reported in a public
   forum.

Perhaps that should read:
   [...], unless the problem was reported in a public forum.


Paul Bolle

