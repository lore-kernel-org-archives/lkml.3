Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaLHUnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:43:18 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64344 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489AbaLHUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:43:15 -0500
Message-ID: <1418071392.2058.56.camel@x220>
Subject: Re: [PATCH 3/3] kconfig: rename S_BOOLEAN to S_BOOL for consistency
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com
Date: Mon, 08 Dec 2014 21:43:12 +0100
In-Reply-To: <7fa2d6b65dfd4d5549baf8cbc53b6940b00fe52d.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
	 <7fa2d6b65dfd4d5549baf8cbc53b6940b00fe52d.1418003065.git.cj@linux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 20:43:12.0598 (UTC) FILETIME=[9576AF60:01D01327]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-07 at 20:49 -0500, Christoph Jaeger wrote:
> Rename S_BOOLEAN to S_BOOL so that it reflects the actual string as
> S_TRISTATE, S_INT, etc., do. No functional changes.
> 
> Signed-off-by: Christoph Jaeger <cj@linux.com>

If you resend this series, and take in account my comments on 2/3, feel
free to add:
    Acked-by: Paul Bolle <pebolle@tiscali.nl>

to this patch.

Thanks,


Paul Bolle

