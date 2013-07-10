Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3GJUFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:05:36 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:42033 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3GJUFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130710093844.GD14873@pd.tnic>
References: <CA+8MBbKU-YHrVvV6uxE2gJ8Ko=06o=_y90peUBsC4SvOXMLO_w@mail.gmail.com>
	<20130710092225.20744.63823.stgit@localhost.localdomain>
	<20130710093844.GD14873@pd.tnic>
Date: Wed, 10 Jul 2013 13:05:33 -0700
Message-ID: <CA+8MBb+maun-q=6o9vo5gqE0HtxKF=NoLs_eG8WEeH+=-Ojd1w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mce, acpi/apei: Soft-offline a page on firmware
 GHES notification
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>
> Acked-by: Borislav Petkov <bp@suse.de>

Applied-by: Tony Luck :-)

Naveen: Thanks for having this idea, implementing it, and sticking
with it through the review process.

Once 3.11-rc1 is out I'll ask Ingo to pull this series to the tip tree
... and then on to 3.12

-Tony
