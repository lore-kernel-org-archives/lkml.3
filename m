Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaLHSvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:51:06 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58834 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755780AbaLHSvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:51:04 -0500
Message-ID: <1418064660.2058.11.camel@x220>
Subject: Re: [PATCH 2/3] kconfig: remove undocumented type definition alias
 'boolean'
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com
Date: Mon, 08 Dec 2014 19:51:00 +0100
In-Reply-To: <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
	 <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 18:51:00.0760 (UTC) FILETIME=[E8F9B980:01D01317]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-07 at 20:49 -0500, Christoph Jaeger wrote:
> Having an undocumented alias for type definitions of boolean config options is
> more confusing than helpful. Remove support for the keyword 'boolean' in favor
> of 'bool' and convert all its users.
> 
> While at it, fix some minor grammar issues in warning messages.
> 
> Suggested-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Christoph Jaeger <cj@linux.com>

This doesn't apply on next-20141208. What tree did you base this on?

Thanks,


Paul Bolle

