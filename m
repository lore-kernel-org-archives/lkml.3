Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaEGJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:23:29 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57498 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265AbaEGJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:23:27 -0400
Message-ID: <1399454604.6659.13.camel@x220>
Subject: Re: [PATCH] libata-sff: remove dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Cox <alan@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 May 2014 11:23:24 +0200
In-Reply-To: <1399411616.2458.45.camel@acox1-desk.ger.corp.intel.com>
References: <1399204229.8729.15.camel@x220>
	 <1399411616.2458.45.camel@acox1-desk.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2014 09:23:25.0005 (UTC) FILETIME=[FF59A7D0:01CF69D5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added David.]

On Tue, 2014-05-06 at 22:26 +0100, Alan Cox wrote:
> On Sun, 2014-05-04 at 13:50 +0200, Paul Bolle wrote:
> > Ever since v2.6.19 the code contains a check for CONFIG_NO_ATA_LEGACY.
> > But that macro has never been defined. Apparently no one ran into
> > problems on platforms that do not support compatibility mode.
> 
> It was needed for some of the FRV devices I belive. Please check with
> David Howells if it's still relevant

This code has been behind (effectively) an "#if 0" check for seven
years. So either there was no problem to begin with, the problem is
fixed somewhere else, or no one is actually using the affected devices.
So I doubt this is still relevant. But maybe David thinks otherwise...

> (even if its not used in the default configs)

It's not used (and has never been used) regardless which config one
tries.


Paul Bolle

