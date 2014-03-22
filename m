Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaCVQgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:36:06 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53250 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbaCVQgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:36:02 -0400
Message-ID: <1395506158.2159.2.camel@x220>
Subject: Re: [PATCH 3.13 072/149] ACPI / resources: ignore invalid ACPI
 device resources
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sat, 22 Mar 2014 17:35:58 +0100
In-Reply-To: <20140322162638.GE13385@kroah.com>
References: <20140321000436.377902063@linuxfoundation.org>
	 <20140321000439.452672105@linuxfoundation.org>
	 <201403220230.49584.s.L-H@gmx.de> <20140322162638.GE13385@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2014 16:35:59.0717 (UTC) FILETIME=[CE8FE950:01CF45EC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-22 at 09:26 -0700, Greg Kroah-Hartman wrote:
> Is this also a problem in Linus's tree?  If so, shouldn't a fix go there
> first?

That fix is commit 89935315f192 ("PNP / ACPI: proper handling of ACPI
IO/Memory resource parsing failures"), included in v3.14-rc7.


Paul Bolle

