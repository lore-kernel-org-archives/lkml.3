Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaBPTKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:10:07 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:64345 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbaBPTKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:10:05 -0500
Message-ID: <1392577801.28866.35.camel@x220>
Subject: Re: [PATCH] sh: remove SH_ALPHA_BOARD
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 20:10:01 +0100
In-Reply-To: <1392577203.28866.29.camel@x220>
References: <1392577203.28866.29.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 19:10:03.0100 (UTC) FILETIME=[B200B9C0:01CF2B4A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 20:00 +0100, Paul Bolle wrote:
> The Kconfig symbol SH_ALPHA_BOARD was added in v2.6.38. It has never
> been used. Setting it has no effect. There are no calls for
> mach_is_sh_alpha_board(). This symbol can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Paul Mundt's address triggers a bounce. I received a bounce for a
message I sent Paul last week too. Do other people have problems sending
to lethal@linux-sh.org too?


Paul Bolle

