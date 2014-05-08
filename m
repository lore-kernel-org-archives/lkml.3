Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaEHHGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:06:06 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53890 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbaEHHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:06:05 -0400
Message-ID: <1399532762.19191.3.camel@x41>
Subject: Re: Build regressions/improvements in v3.15-rc4
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 08 May 2014 09:06:02 +0200
In-Reply-To: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
References: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 May 2014 07:06:02.0912 (UTC) FILETIME=[F917D200:01CF6A8B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven schreef op di 06-05-2014 om 14:04 [+0200]:
>   + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]:  => 405:4

The fix for this warning is (finally) queued for next (see
https://lkml.org/lkml/2014/4/28/283 ). Should it be pushed for one of
the upcoming release candidates too?


Paul Bolle

