Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab3GXBuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:50:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43441 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750780Ab3GXBuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:50:02 -0400
Message-ID: <1374630600.10171.31.camel@joe-AO722>
Subject: Re: [PATCH 10/27] drivers/memory: don't check resource with
 devm_ioremap_resource
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 18:50:00 -0700
In-Reply-To: <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	 <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Wolfram

The next time you submit a patch series
please use a [PATCH 0/N] cover-letter
with a description of all the patches
and cc all the various email lists
on that [PATCH 0/N].

This cover letter can be created via
	git format-patch --cover-letter

That way, general replies to the series
can be to the 0/N cover letter and all
mailing lists can receive it.


