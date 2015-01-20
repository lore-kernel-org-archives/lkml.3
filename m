Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbATWpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:45:03 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:54217 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbbATWpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:45:01 -0500
Message-ID: <1421793899.29393.8.camel@x220>
Subject: Re: [PATCH] checkpatch: Add ability to coalesce commit descriptions
 on multiple lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hsselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 23:44:59 +0100
In-Reply-To: <1421792716.2724.11.camel@perches.com>
References: <1421659937.9655.16.camel@x220> <1421660338.9655.21.camel@x220>
	 <1421792716.2724.11.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2015 22:45:00.0126 (UTC) FILETIME=[B8DA37E0:01D03502]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe, Andrew,

On Tue, 2015-01-20 at 14:25 -0800, Joe Perches wrote:
> If a git commit description is split on consecutive lines,
> coalesce it before testing.
> 
> This allows:
> 
>   commit <foo> ("some long
>   description")
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Noticed-by: Paul Bolle <pebolle@tiscali.nl>

Works as advertised (ie, that particular commit explanation doesn't
trigger an error anymore). And Andrew M. already added it to the -mm
tree.

Thanks, both of you!


Paul Bolle

