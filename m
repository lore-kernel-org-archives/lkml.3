Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBQIuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:50:44 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60010 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbaBQIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:50:43 -0500
Message-ID: <1392627040.10966.18.camel@x220>
Subject: Re: [PATCH] s390: remove HAVE_MARCH_Z9?0_FEATURES
From: Paul Bolle <pebolle@tiscali.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 09:50:40 +0100
In-Reply-To: <20140217082035.GA4651@osiris>
References: <1392570927.28866.12.camel@x220> <20140217082035.GA4651@osiris>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2014 08:50:41.0989 (UTC) FILETIME=[56AAEF50:01CF2BBD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 09:20 +0100, Heiko Carstens wrote:
> On Sun, Feb 16, 2014 at 06:15:27PM +0100, Paul Bolle wrote:
> No, I want to keep them, so there is a config symbol for each cpu generation
> and we don't have to add the config symbols again, if we actually use them.

Yes, that's the idea: only add Kconfig symbols that you are actually
going to use.

> It's a question of completeness in this case, not if they are being used.

Completeness of what?

Anyhow, perhaps you can comment this stuff out if you want to have it in
the tree. See, these symbols will pop up each time that people run their
scripts to discover problems in the kconfig space. I suppose this was
probably not the first time these two were reported. And people not
aware of this thread might do that again, and again...

Thanks,


Paul Bolle

